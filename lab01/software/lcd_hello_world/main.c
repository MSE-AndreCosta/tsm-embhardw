/*
 * main.c
 *
 *  Created on: Oct 11, 2025
 *      Author: andre
 */

#include "lcd.h"
#include "timer.h"
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include "system.h"
#include "io.h"

static uint16_t draw_buffer[LCD_WIDTH * LCD_HEIGHT];

int main()
{
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x0, 0xFFFFFFFF);
	IOWR_32DIRECT(PARALLELPORT_0_BASE, 0x8, 0x0);
	IOWR_32DIRECT(PARALLELPORT_1_BASE, 0x0, 0xFFFFFFFF);
	IOWR_8DIRECT(PARALLELPORT_1_BASE, 0x2, 0x00);
	IOWR_8DIRECT(PARALLELPORT_1_BASE, 0x2, 0xFF);

	timer_init();
	lcd_init();
	memset(draw_buffer, 0xF800, LCD_WIDTH * LCD_HEIGHT * sizeof(*draw_buffer));

	lcd_select();
	lcd_write(draw_buffer);
	lcd_unselect();

	while (1)
		;
}
