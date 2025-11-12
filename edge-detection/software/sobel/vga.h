/*
 * vga.h
 *
 *  Created on: Aug 25, 2015
 *      Author: theo
 */

#ifndef VGA_H_
#define VGA_H_

void vga_set_pointer(void *image);
void vga_set_swap(char swap);

#define VGA_RED_BLUE_SWAP 1
#define VGA_TEST_SCREEN	  2
#define VGA_FLIP_X	  4
#define VGA_QuarterScreen 8
#define VGA_Grayscale	  16

#endif /* VGA_H_ */
