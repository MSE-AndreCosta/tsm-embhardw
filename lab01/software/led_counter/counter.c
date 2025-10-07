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

void timer interrupt(void *context, alt u32 id){
	counter++;
	IOWR_8DIRECT(PARALLELPORT_0_BASE, 0x8, counter);
	IOWR_16DIRECT(TIMER_0_BASE, 0, 0x0);
}

int main() {
	printf("Let's start counting\n");

	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x0, 0xFF);
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x8, 0);

	alt_irq_register(TIMER 0 IRQ,(void*)2,(alt isr func)timer interrupt);
	IOWR_16DIRECT(TIMER 0 BASE, 4, 0x7);

	while(1) ;

}
