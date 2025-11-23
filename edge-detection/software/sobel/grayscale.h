/*
 * grayscale.h
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#ifndef GRAYSCALE_H_
#define GRAYSCALE_H_

void init_grayscale(int width, int height);
void conv_grayscale(void *picture, int width, int height);
int get_grayscale_width();
int get_grayscale_height();
unsigned char *get_grayscale_picture();
void conv_grayscale_chunk(void *picture, int width, int height, int start_row, int rows_to_process,
			  unsigned char *output_buffer);

#endif /* GRAYSCALE_H_ */
