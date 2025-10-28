#ifndef LCD_H
#define LCD_H

#include <stdint.h>
#include <stdbool.h>

#define LCD_WIDTH  240
#define LCD_HEIGHT 320

void lcd_init(void);
void lcd_select(void);
void lcd_unselect(void);
void lcd_start_dma_transfer(void);
bool lcd_can_write(void);
void lcd_write_direct(const uint16_t *buffer, uint32_t size);
void lcd_write_async(const uint16_t *buffer, uint32_t size);
#endif /*LCD_H*/
