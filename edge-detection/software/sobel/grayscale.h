/*
 * grayscale.h
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#ifndef GRAYSCALE_H_
#define GRAYSCALE_H_

#include <stdint.h>

void init_grayscale(int width, int height);
void conv_grayscale(void *picture, int width, int height);
int get_grayscale_width();
int get_grayscale_height();
unsigned char *get_grayscale_picture();

void conv_grayscale_chunk(void *picture, uint32_t start_row, uint32_t row_count);

#endif /* GRAYSCALE_H_ */
