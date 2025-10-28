#ifndef LCD_H
#define LCD_H

#include <stdint.h>

#define LCD_WIDTH  240
#define LCD_HEIGHT 320

void lcd_init(void);
void lcd_select(void);
void lcd_unselect(void);
void lcd_write(const uint16_t *buffer, uint32_t size);
void lcd_start_dma_transfer(void);
void lcd_ack_transfer(void);
#endif /*LCD_H*/
