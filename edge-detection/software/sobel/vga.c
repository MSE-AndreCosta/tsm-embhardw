/*
 * vga.c
 *
 *  Created on: Aug 25, 2015
 *      Author: theo
 */

#include <system.h>
#include <io.h>

void vga_set_pointer(void *image)
{
	IOWR_32DIRECT(VGA_DMA_0_BASE, 0, (int)image);
}

void vga_set_swap(char swap)
{
	IOWR_8DIRECT(VGA_DMA_0_BASE, 4, swap);
}
