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

unsigned char *grayscale_array;
int grayscale_width = 0;
int grayscape_height = 0;

void init_grayscale(int width, int height)
{
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

void conv_grayscale_chunk(void *picture, int width, int height, int start_row, int rows_to_process,
			  unsigned char *output_buffer)
{
	int x, y, gray;
	unsigned short *pixels = (unsigned short *)picture;
	unsigned short rgb;
	unsigned idx = 0;

	for (y = 0; y < rows_to_process; y++) {
		for (x = 0; x < width; x++) {
			rgb = pixels[idx++];
			gray = ((rgb >> 5) & 0x3F) << 2;
			output_buffer[(start_row + y) * width + x] = gray;
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
