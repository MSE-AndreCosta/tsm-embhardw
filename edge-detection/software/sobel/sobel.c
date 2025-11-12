/*
 * sobel.c
 *
 *  Created on: Sep 12, 2015
 *      Author: theo
 */

#include <stdlib.h>
#include <stdio.h>
#include "io.h"

const char gx_array[3][3] = { { -1, 0, 1 }, { -2, 0, 2 }, { -1, 0, 1 } };
const char gy_array[3][3] = { { 1, 2, 1 }, { 0, 0, 0 }, { -1, -2, -1 } };

short *sobel_x_result;
short *sobel_y_result;
unsigned short *sobel_rgb565;
unsigned char *sobel_result;
int sobel_width;
int sobel_height;

void init_sobel_arrays(int width, int height)
{
	printf("Init sobel arrays %dx%d. Pixel Count = %d", width, height, width * height);
	int loop;
	sobel_width = width;
	sobel_height = height;
	if (sobel_x_result != NULL)
		free(sobel_x_result);
	sobel_x_result = (short *)malloc(width * height * sizeof(short));
	if (sobel_y_result != NULL)
		free(sobel_y_result);
	sobel_y_result = (short *)malloc(width * height * sizeof(short));
	if (sobel_result != NULL)
		free(sobel_result);
	sobel_result = (unsigned char *)malloc(width * height * sizeof(unsigned char));
	if (sobel_rgb565 != NULL)
		free(sobel_rgb565);
	sobel_rgb565 = (unsigned short *)malloc(width * height * sizeof(unsigned short));
	for (loop = 0; loop < width * height; loop++) {
		sobel_x_result[loop] = 0;
		sobel_y_result[loop] = 0;
		sobel_result[loop] = 0;
		sobel_rgb565[loop] = 0;
	}
}

short sobel_mac(unsigned char *pixels, int x, int y, const char *filter, unsigned int width)
{
	short result = filter[0] * pixels[(y - 1) * width + (x - 1)];
	result += filter[1] * pixels[(y - 1) * width + x];
	result += filter[2] * pixels[(y - 1) * width + (x + 1)];
	result += filter[3] * pixels[y * width + (x - 1)];
	result += filter[4] * pixels[y * width + x];
	result += filter[5] * pixels[y * width + (x + 1)];
	result += filter[6] * pixels[(y + 1) * width + (x - 1)];
	result += filter[7] * pixels[(y + 1) * width + x];
	result += filter[8] * pixels[(y + 1) * width + (x + 1)];
	return result;
}

void sobel_complete(unsigned char *pixels)
{
	int x, y;

	for (y = 1; y < (sobel_height - 1); y++) {
		for (x = 1; x < (sobel_width - 2); x += 2) {
			short x_result = -pixels[(y - 1) * sobel_width + (x - 1)] + (pixels[(y - 1) * sobel_width + (x + 1)]) -
					 (pixels[y * sobel_width + (x - 1)] << 1) + (pixels[y * sobel_width + (x + 1)] << 1) -
					 pixels[(y + 1) * sobel_width + (x - 1)] + pixels[(y + 1) * sobel_width + (x + 1)];

			short y_result = pixels[(y - 1) * sobel_width + (x - 1)] + (pixels[(y - 1) * sobel_width + x] << 1) +
					 pixels[(y - 1) * sobel_width + (x + 1)] - pixels[(y + 1) * sobel_width + (x - 1)] -
					 (pixels[(y + 1) * sobel_width + x] << 1) - pixels[(y + 1) * sobel_width + (x + 1)];

			sobel_x_result[y * sobel_width + x] = x_result;
			sobel_x_result[y * sobel_width + x + 1] = x_result;

			sobel_y_result[y * sobel_width + x] = y_result;
			sobel_y_result[y * sobel_width + x + 1] = y_result;
		}
	}
}

void sobel_x(unsigned char *pixels)
{
	int x, y;
	const char *filter = (const char *)gx_array;

	for (y = 1; y < (sobel_height - 1); y++) {
		for (x = 1; x < (sobel_width - 1); x++) {
			short result = filter[0] * pixels[(y - 1) * sobel_width + (x - 1)];
			result += filter[1] * pixels[(y - 1) * sobel_width + x];
			result += filter[2] * pixels[(y - 1) * sobel_width + (x + 1)];
			result += filter[3] * pixels[y * sobel_width + (x - 1)];
			result += filter[4] * pixels[y * sobel_width + x];
			result += filter[5] * pixels[y * sobel_width + (x + 1)];
			result += filter[6] * pixels[(y + 1) * sobel_width + (x - 1)];
			result += filter[7] * pixels[(y + 1) * sobel_width + x];
			result += filter[8] * pixels[(y + 1) * sobel_width + (x + 1)];
			sobel_x_result[y * sobel_width + x] = result;
		}
	}
}

void sobel_x_with_rgb(unsigned char *source)
{
	int x, y;
	short result;

	for (y = 1; y < (sobel_height - 1); y++) {
		for (x = 1; x < (sobel_width - 1); x++) {
			result = sobel_mac(source, x, y, (const char *)gx_array, sobel_width);

			sobel_x_result[y * sobel_width + x] = result;
			if (result < 0) {
				sobel_rgb565[y * sobel_width + x] = ((-result) >> 2) << 5;
			} else {
				sobel_rgb565[y * sobel_width + x] = ((result >> 3) & 0x1F) << 11;
			}
		}
	}
}

void sobel_y(unsigned char *pixels)
{
	int x, y;
	const char *filter = (const char *)gx_array;
	for (y = 1; y < (sobel_height - 1); y++) {
		for (x = 1; x < (sobel_width - 1); x++) {
			short result = filter[0] * pixels[(y - 1) * sobel_width + (x - 1)];
			result += filter[1] * pixels[(y - 1) * sobel_width + x];
			result += filter[2] * pixels[(y - 1) * sobel_width + (x + 1)];
			result += filter[3] * pixels[y * sobel_width + (x - 1)];
			result += filter[4] * pixels[y * sobel_width + x];
			result += filter[5] * pixels[y * sobel_width + (x + 1)];
			result += filter[6] * pixels[(y + 1) * sobel_width + (x - 1)];
			result += filter[7] * pixels[(y + 1) * sobel_width + x];
			result += filter[8] * pixels[(y + 1) * sobel_width + (x + 1)];
			sobel_y_result[y * sobel_width + x] = result;
		}
	}
}

void sobel_y_with_rgb(unsigned char *source)
{
	int x, y;
	short result;

	for (y = 1; y < (sobel_height - 1); y++) {
		for (x = 1; x < (sobel_width - 1); x++) {
			result = sobel_mac(source, x, y, (const char *)gy_array, sobel_width);
			sobel_y_result[y * sobel_width + x] = result;
			if (result < 0) {
				sobel_rgb565[y * sobel_width + x] = ((-result) >> 2) << 5;
			} else {
				sobel_rgb565[y * sobel_width + x] = ((result >> 3) & 0x1F) << 11;
			}
		}
	}
}

void sobel_threshold(short threshold)
{
	int x, y, arrayindex;
	for (y = 1; y < (sobel_height - 1); y++) {
		for (x = 1; x < (sobel_width - 1); x++) {
			arrayindex = (y * sobel_width) + x;
			short x = sobel_x_result[arrayindex];
			x = x > 0 ? x : -x;
			short y = sobel_y_result[arrayindex];
			y = y > 0 ? y : -y;
			sobel_result[arrayindex] = (x + y > threshold) ? 0xFF : 0;
		}
	}
}

unsigned short *GetSobel_rgb()
{
	return sobel_rgb565;
}

unsigned char *GetSobelResult()
{
	return sobel_result;
}
