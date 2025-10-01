/*
 * counter.c
 *
 *  Created on: Oct 1, 2025
 *      Author: andre
 */


#include "io.h"
#include <stdio.h>
#include "system.h"

int main() {
	printf("Let's start counting\n");
	int counter = 0;
#if 0
	IOWR_8DIRECT(LEDS_BASE, 0, 0);
	while(1)
	{
		counter++;
		printf("counter = %2d\n", counter);
		IOWR_8DIRECT(LEDS_BASE, 0, counter);
	}
#endif
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x0, 0xFF);
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x8, 0);

	while(1)
	{
		counter++;
		printf("counter = %2d\n", counter);
		IOWR_8DIRECT(PARALLELPORT_0_BASE, 0x8, counter);
	}

}
