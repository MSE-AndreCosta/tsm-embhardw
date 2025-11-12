#include <stdio.h>
#include <stdint.h>
#include <system.h>
#include <stdlib.h>
#include <io.h>
#include "lcd_simple.h"
#include "grayscale.h"
#include "i2c.h"
#include "camera.h"
#include "vga.h"
#include "dipswitch.h"
#include "sobel.h"
#include "sys/alt_timestamp.h"
#include "alt_types.h"

#define MEASURE(fn, ...)                                                                              \
	do {                                                                                          \
		printf("Calling %s\n", #fn);                                                          \
		alt_u32 start = alt_timestamp() / (alt_timestamp_freq() / 1000);                      \
		fn(__VA_ARGS__);                                                                      \
		alt_u32 end = alt_timestamp() / (alt_timestamp_freq() / 1000);                        \
		printf("Function %s took: %lu ms - %lu ms = %lu ms\n", #fn, end, start, end - start); \
	} while (0);

int main()
{
	init_LCD();
	init_camera();
	vga_set_swap(VGA_QuarterScreen | VGA_Grayscale);
	printf("Hello from Nios II!\n");
	cam_get_profiling();
	void *buffer1 = malloc(cam_get_xsize() * cam_get_ysize());
	void *buffer2 = malloc(cam_get_xsize() * cam_get_ysize());
	void *buffer3 = malloc(cam_get_xsize() * cam_get_ysize());
	void *buffer4 = malloc(cam_get_xsize() * cam_get_ysize());
	cam_set_image_pointer(0, buffer1);
	cam_set_image_pointer(1, buffer2);
	cam_set_image_pointer(2, buffer3);
	cam_set_image_pointer(3, buffer4);
	enable_continues_mode();
	init_sobel_arrays(cam_get_xsize() >> 1, cam_get_ysize());
	alt_timestamp_start();
	while (1) {
		if (!new_image_available()) {
			continue;
		}
		if (!current_image_valid()) {
			continue;
		}
		const uint8_t current_mode = DIPSW_get_value();
		const uint8_t mode = current_mode & (DIPSW_SW1_MASK | DIPSW_SW3_MASK | DIPSW_SW2_MASK);
		uint16_t *image = (uint16_t *)current_image_pointer();
		uint8_t *grayscale = NULL;
		printf("Mode is %d %lu\n", mode, alt_timestamp() / alt_timestamp_freq());
		switch (mode) {
		case 0:
			transfer_LCD_with_dma(&image[16520], cam_get_xsize() >> 1, cam_get_ysize(), 0);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen);
				vga_set_pointer(image);
			}
			break;
		case 1:
			MEASURE(conv_grayscale, (void *)image, cam_get_xsize() >> 1, cam_get_ysize());
			grayscale = get_grayscale_picture();
			transfer_LCD_with_dma(&grayscale[16520], cam_get_xsize() >> 1, cam_get_ysize(), 1);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen | VGA_Grayscale);
				vga_set_pointer(grayscale);
			}
			break;
		case 2:
			MEASURE(conv_grayscale, (void *)image, cam_get_xsize() >> 1, cam_get_ysize());
			grayscale = get_grayscale_picture();
			sobel_x_with_rgb(grayscale);
			image = GetSobel_rgb();
			transfer_LCD_with_dma(&image[16520], cam_get_xsize() >> 1, cam_get_ysize(), 0);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen);
				vga_set_pointer(image);
			}
			break;
		case 3:
			MEASURE(conv_grayscale, (void *)image, cam_get_xsize() >> 1, cam_get_ysize());
			grayscale = get_grayscale_picture();
			MEASURE(sobel_x, grayscale);
			sobel_y_with_rgb(grayscale);
			image = GetSobel_rgb();
			transfer_LCD_with_dma(&image[16520], cam_get_xsize() >> 1, cam_get_ysize(), 0);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen);
				vga_set_pointer(image);
			}
			break;
		default:
			MEASURE(conv_grayscale, (void *)image, cam_get_xsize() >> 1, cam_get_ysize());
			grayscale = get_grayscale_picture();
#if 0
			MEASURE(sobel_x, grayscale);
			MEASURE(sobel_y, grayscale);
#endif
			MEASURE(sobel_complete, grayscale);
			MEASURE(sobel_threshold, 128);
			grayscale = GetSobelResult();
			transfer_LCD_with_dma(&grayscale[16520], cam_get_xsize() >> 1, cam_get_ysize(), 1);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen | VGA_Grayscale);
				vga_set_pointer(grayscale);
			}
			break;
		}
	}
	return 0;
}
