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
	IOWR_8DIRECT(LEDS_BASE, 0, 0);
	int counter = 0;
	while(1)
	{
		counter++;
		printf("counter = %2d\n", counter);
		IOWR_8DIRECT(LEDS_BASE, 0, counter);
	}
}
