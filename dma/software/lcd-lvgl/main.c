/*
 * main.c
 *
 *  Created on: Oct 11, 2025
 *      Author: andre
 */

#include "lcd.h"
#include "lvgl/lvgl.h"
#include "lvgl/examples/lv_examples.h"
#include "lvgl/src/display/lv_display.h"
#include "lvgl/src/misc/lv_area.h"
#include "timer.h"
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "system.h"
#include "io.h"

static uint16_t draw_buffer[LCD_WIDTH * LCD_HEIGHT];
typedef enum { RENDERING, FLUSHING, WAITING } state_t;

static void flush_cb(lv_display_t *disp, const lv_area_t *area, uint8_t *px_map)
{
	if (!lv_display_flush_is_last(disp)) {
		lv_display_flush_ready(disp);
		return;
	}
	lcd_write_async(draw_buffer, sizeof(draw_buffer));
}

static void lcd_ready_cb(void *data, uint32_t tick)
{
	(void)tick;
	lv_display_flush_ready(data);
}

int main(void)
{
	IOWR_32DIRECT(PARALLEL_PORT_0_BASE, 0x0, 0xFFFFFFFF);
	IOWR_32DIRECT(PARALLEL_PORT_0_BASE, 0x8, 0x0);

	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x0, 0xFF);
	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x2, 0x00);
	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x2, 0xFF);

	timer_init();
	lcd_init();
	lv_init();
	lv_tick_set_cb(timer_get_tick);

	lv_display_t *display = lv_display_create(LCD_WIDTH, LCD_HEIGHT);
	lv_display_set_buffers(display, draw_buffer, NULL, sizeof(draw_buffer), LV_DISPLAY_RENDER_MODE_DIRECT);
	lv_display_set_flush_cb(display, flush_cb);
	lcd_set_ready_cb(lcd_ready_cb, display);
	lv_example_arc_2();

	while (1) {
		lv_timer_handler();
	}
}
