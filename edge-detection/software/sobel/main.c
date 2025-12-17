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

#define USABLE_CACHE	     (NIOS2_DCACHE_SIZE * 0.7f)
#define CHUNK_ROWS	     (uint32_t)(USABLE_CACHE / GRAYSCALE_WIDTH)

#define BATCH_COUNT	     (GRAYSCALE_HEIGHT / CHUNK_ROWS)
#define LAST_BATCH_ROW_COUNT (GRAYSCALE_HEIGHT % CHUNK_ROWS)

unsigned char *grayscale = NULL;

static void do_chunk_processing(void *image)
{
	for (uint32_t i = 0; i < BATCH_COUNT * CHUNK_ROWS; i += CHUNK_ROWS) {
		conv_grayscale_chunk(image, i, CHUNK_ROWS);
		sobel_complete_chunk(grayscale, i, CHUNK_ROWS);
	}

	if (LAST_BATCH_ROW_COUNT > 0) {
		conv_grayscale_chunk(image, BATCH_COUNT * CHUNK_ROWS, LAST_BATCH_ROW_COUNT);
		sobel_complete_chunk(grayscale, BATCH_COUNT * CHUNK_ROWS, LAST_BATCH_ROW_COUNT);
	}
}

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
	uint32_t width = cam_get_xsize() >> 1;
	uint32_t height = cam_get_ysize();
	init_sobel_arrays(GRAYSCALE_WIDTH, GRAYSCALE_HEIGHT);
	init_grayscale(width, height);
	grayscale = get_grayscale_picture();

	uint8_t *result = GetSobelResult();

	printf("Usable cache is %.2f. Chunk rows %ld\n", USABLE_CACHE, CHUNK_ROWS);

	while (1) {
		alt_timestamp_start();
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
		switch (mode) {
		case 0:
			transfer_LCD_with_dma(&image[16520], cam_get_xsize() >> 1, cam_get_ysize(), 0);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen);
				vga_set_pointer(image);
			}
			break;
		case 1:
			conv_grayscale((void *)image, cam_get_xsize() >> 1, cam_get_ysize());
			grayscale = get_grayscale_picture();
			transfer_LCD_with_dma(&grayscale[16520], cam_get_xsize() >> 1, cam_get_ysize(), 1);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen | VGA_Grayscale);
				vga_set_pointer(grayscale);
			}
			break;
		case 2:
			conv_grayscale((void *)image, cam_get_xsize() >> 1, cam_get_ysize());
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
			conv_grayscale((void *)image, cam_get_xsize() >> 1, cam_get_ysize());
			grayscale = get_grayscale_picture();
			sobel_x(grayscale);
			sobel_y_with_rgb(grayscale);
			image = GetSobel_rgb();
			transfer_LCD_with_dma(&image[16520], cam_get_xsize() >> 1, cam_get_ysize(), 0);
			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen);
				vga_set_pointer(image);
			}
			break;
		default: {
#if 1
			alt_u32 start = alt_timestamp() / (alt_timestamp_freq() / 1000);
			do_chunk_processing(image);
			alt_u32 end = alt_timestamp() / (alt_timestamp_freq() / 1000);

			printf("Chunk based Processing took: %lu ms - %lu ms = %lu ms\n", end, start, end - start);
#else

			alt_u32 start = alt_timestamp() / (alt_timestamp_freq() / 1000);
			conv_grayscale((void *)image, width, height);
			uint8_t *result = get_grayscale_picture();
			sobel_complete(result, 128);
			result = GetSobelResult();
			alt_u32 end = alt_timestamp() / (alt_timestamp_freq() / 1000);
			printf("Complete processing took: %lu ms - %lu ms = %lu ms\n", end, start, end - start);
#endif

			//transfer_LCD_with_dma(&result[16520], CAMERA_WIDTH, CAMERA_HEIGHT, 1);
			transfer_LCD_with_dma(result, GRAYSCALE_WIDTH, GRAYSCALE_HEIGHT, 1);

			if ((current_mode & DIPSW_SW8_MASK) != 0) {
				vga_set_swap(VGA_QuarterScreen | VGA_Grayscale);
				vga_set_pointer(grayscale);
			}
			break;
		}
		}
	}
	return 0;
}
