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
#include <stdbool.h>
#include "system.h"
#include "io.h"

static uint16_t draw_buffer[LCD_WIDTH * LCD_HEIGHT];
typedef enum { RENDERING, FLUSHING, WAITING } state_t;
int main()
{
	IOWR_32DIRECT(PARALLEL_PORT_0_BASE, 0x0, 0xFFFFFFFF);
	IOWR_32DIRECT(PARALLEL_PORT_0_BASE, 0x8, 0x0);

	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x0, 0xFF);
	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x2, 0x00);
	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x2, 0xFF);

	timer_init();
	lcd_init();

	for (size_t i = 0; i < LCD_WIDTH * LCD_HEIGHT; ++i) {
		size_t x = i % LCD_WIDTH;
		size_t y = i / LCD_WIDTH;

		bool is_first_color = ((x / 8) + (y / 8)) % 2 == 0;

		// RGB565 colors: Red = 0xF800, Blue = 0x001F
		draw_buffer[i] = is_first_color ? 0xF800 : 0x00F8;
	}

	state_t state = RENDERING;
	uint32_t last_tick;

	uint32_t sum = 0;
	for (size_t i = 0; i < 10; ++i) {
		uint32_t start = timer_get_tick();
		lcd_write_direct(draw_buffer, LCD_WIDTH * LCD_HEIGHT * sizeof(*draw_buffer));
		uint32_t end = timer_get_tick();
		printf("Direct CPU write took %d\n", end - start);
		sum += end - start;
	}
	printf("Average direct cpu write %d\n", sum / 10);
	uint32_t start = 0;
	while (1) {
		uint32_t tick = timer_get_tick();
		IOWR_32DIRECT(PARALLEL_PORT_0_BASE, 0x8, tick);
		switch (state) {
		case RENDERING:
			for (size_t i = 0; i < LCD_WIDTH * LCD_HEIGHT; ++i) {
				if (draw_buffer[i] == 0xF800) {
					draw_buffer[i] = 0x00F8;
				} else {
					draw_buffer[i] = 0xF800;
				}
			}
			last_tick = tick;
			printf("Finished rendering: %u\n", last_tick);
			start = timer_get_tick();
			lcd_write_async(draw_buffer, LCD_WIDTH * LCD_HEIGHT * sizeof(*draw_buffer));
			state = FLUSHING;
			break;
		case FLUSHING:
			if (lcd_can_write()) {
				printf("Async Flush took %d\n", lcd_get_isr_tick() - start);
				state = RENDERING;
			}
			break;
		case WAITING:
			if (tick - last_tick >= 5000) {
				printf("Starting rendering. %u (+%u)\n", tick, tick - last_tick);
				state = RENDERING;
			}
			break;
		}
	}
}
