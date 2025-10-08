/*
 * counter.c
 *
 *  Created on: Oct 1, 2025
 *      Author: andre
 */

#include "io.h"
#include <stdio.h>
#include "system.h"

volatile unsigned long counter;

static void timer_isr(void *context, alt_u32 id)
{
	counter++;
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x8, counter);
	IOWR_16DIRECT(TIMER_0_BASE, 0, 0x0);
}

int main()
{
	printf("Let's start counting\n");

	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x0, 0xFFFFFFFF);
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x8, 0x0);
	alt_irq_register(TIMER_0_IRQ, (void *)2, timer_isr);
	IOWR_16DIRECT(TIMER_0_BASE, 4, 0x7);
	while (1)
		;
}
