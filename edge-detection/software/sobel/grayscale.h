/*
 * grayscale.h
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#ifndef GRAYSCALE_H_
#define GRAYSCALE_H_

void conv_grayscale(void *picture, int width, int height);
int get_grayscale_width();
int get_grayscale_height();
unsigned char *get_grayscale_picture();

#endif /* GRAYSCALE_H_ */
