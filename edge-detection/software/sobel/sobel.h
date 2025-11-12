/*
 * sobel.h
 *
 *  Created on: Sep 12, 2015
 *      Author: theo
 */

#ifndef SOBEL_H_
#define SOBEL_H_

void init_sobel_arrays(int width, int height);
void sobel_x(unsigned char *source);
void sobel_x_with_rgb(unsigned char *source);
void sobel_y(unsigned char *source);
void sobel_y_with_rgb(unsigned char *source);
void sobel_threshold(short threshold);
void sobel_complete(unsigned char *pixels);
unsigned short *GetSobel_rgb();
unsigned char *GetSobelResult();

#endif /* SOBEL_H_ */
