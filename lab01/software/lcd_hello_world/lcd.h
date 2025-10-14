#ifndef LCD_H
#define LCD_H

#include <stdint.h>

#define LCD_WIDTH  240
#define LCD_HEIGHT 320

void lcd_init(void);
void lcd_select(void);
void lcd_unselect(void);
void lcd_write(const uint16_t *buffer);

#endif /*LCD_H*/
