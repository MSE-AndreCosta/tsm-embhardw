/*
 * lcd_simple.h
 *
 *  Created on: Aug 20, 2015
 *      Author: theo
 */

#ifndef LCD_SIMPLE_H_
#define LCD_SIMPLE_H_

void init_LCD();
void LCD_Write_Command(int command);
void LCD_Write_Data(int data);
void transfer_LCD_no_dma(void *array, int width, int height);
void transfer_LCD_with_dma(void *array, int width, int height, char grayscale);

#define LCD_COMMAND_REG	      0
#define LCD_DATA_REG	      4
#define LCD_CONTROL_REG	      8
#define LCD_IMAGE_POINTER_REG 12
#define LCD_IMAGE_SIZE_REG    16
#define LCD_NR_PIX_LINE_REG   20
#define LCD_Pict_width_reg    24

#define LCD_Sixteen_Bit	      0
#define LCD_Eight_Bit	      1
#define LCD_Reset	      2
#define LCD_RGB565_Mode	      0
#define LCD_RGB888_Mode	      (1 << 3)
#define LCD_Color_Image	      0
#define LCD_GrayScale_Image   (1 << 4)
#define LCD_IRQ_Disabled      0
#define LCD_IRQ_Enabled	      (1 << 5)
#define LCD_Start_DMA	      (1 << 8)
#define LCD_Clear_IRQ	      (1 << 9)

#endif /* LCD_SIMPLE_H_ */
