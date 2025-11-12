/*
 * grayscale.c
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#include <stdlib.h>
#include <io.h>
#include <system.h>

unsigned char *grayscale_array;
int grayscale_width = 0;
int grayscape_height = 0;

void conv_grayscale(void *picture, int width, int height)
{
	int x, y, gray;
	unsigned short *pixels = (unsigned short *)picture, rgb;
	if (grayscale_width != width || grayscape_height != height) {
		free(grayscale_array);
		grayscale_array = NULL;
	}

	if (!grayscale_array) {
		grayscale_array = (unsigned char *)malloc(width * height);
	}

	grayscale_width = width;
	grayscape_height = height;

	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			rgb = pixels[y * width + x];
			gray = (((rgb >> 11) & 0x1F) << 3) * 21; // red part
			gray += (((rgb >> 5) & 0x3F) << 2) * 72; // green part
			gray += (((rgb >> 0) & 0x1F) << 3) * 7; // blue part
			gray >>= 7;
			IOWR_8DIRECT(grayscale_array, y * width + x, gray);
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
