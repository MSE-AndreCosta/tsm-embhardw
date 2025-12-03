/*
 * grayscale.c
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <io.h>
#include <system.h>

uint8_t *grayscale_array;
uint32_t grayscale_width = 0;
uint32_t grayscape_height = 0;

#define GRAYSCALE_WIDTH 512

void init_grayscale(int width, int height)
{
	printf("Init grayscale arrays %dx%d. Pixel Count = %d", width, height, width * height);

	if (grayscale_width != width || grayscape_height != height) {
		free(grayscale_array);
		grayscale_array = NULL;
	}

	if (!grayscale_array) {
		grayscale_array = (unsigned char *)malloc(width * height);
	}

	grayscale_width = width;
	grayscape_height = height;
}
void conv_grayscale(void *picture, int width, int height)
{
	int x, y, gray;
	unsigned short *pixels = (unsigned short *)picture, rgb;
	init_grayscale(width, height);

	unsigned idx = 0;
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			rgb = pixels[idx++];
			gray = ((rgb >> 5) & 0x3F) << 2; // green part
			IOWR_8DIRECT(grayscale_array, y * width + x, gray);
		}
	}
}
//			const uint16_t rgb = pixels[index];
//			const uint8_t gray = ((rgb >> 5) & 0x3F) << 2;

void conv_grayscale_chunk(void *picture, uint32_t start_row, uint32_t row_count)
{
	uint16_t *pixels = (uint16_t *)picture;
	const unsigned last_row = start_row + row_count;
	uint32_t index = start_row * GRAYSCALE_WIDTH;
	for (uint32_t y = start_row; y < last_row; y++) {
		for (uint32_t x = 0; x < GRAYSCALE_WIDTH - 3; x+=4) {
            const uint32_t a = *((uint32_t*)&pixels[index]);
            const uint32_t b = *((uint32_t*)&pixels[index + 2]);
            const uint32_t result = ALT_CI_RGB_TO_GRAYSCALE_4_0(a, b);
            *((uint32_t*)&grayscale_array[index]) = (uint32_t)result;
			index+=4;
		}
	}
}

int get_grayscale_width()
{
	return grayscale_width;
}

int get_grayscale_height()
{
	return grayscape_height;
}

unsigned char *get_grayscale_picture()
{
	return grayscale_array;
}
