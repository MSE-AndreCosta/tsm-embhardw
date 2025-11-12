/*
 * lcd_simple.c
 *
 *  Created on: Aug 20, 2015
 *      Author: theo
 */

#include <system.h>
#include <io.h>
#include <time.h>
#include "lcd_simple.h"

unsigned short LCD_width;
unsigned short LCD_height;

void LCD_Write_Command(int command)
{
	IOWR_16DIRECT(LCD_CTRL_BASE, LCD_COMMAND_REG, command);
	usleep(10);
}

void LCD_Write_Data(int data)
{
	IOWR_16DIRECT(LCD_CTRL_BASE, LCD_DATA_REG, data);
	usleep(10);
}

void init_LCD()
{
	IOWR_16DIRECT(LCD_CTRL_BASE, LCD_CONTROL_REG,
		      LCD_Sixteen_Bit | LCD_Reset | LCD_RGB565_Mode | LCD_Color_Image); // Set 16 bit transfer mode and reset
	LCD_Write_Command(0x0028); //display OFF
	LCD_Write_Command(0x0011); //exit SLEEP mode
	LCD_Write_Data(0x0000);

	LCD_Write_Command(0x00CB); //Power Control A
	LCD_Write_Data(0x0039); //always 0x39
	LCD_Write_Data(0x002C); //always 0x2C
	LCD_Write_Data(0x0000); //always 0x00
	LCD_Write_Data(0x0034); //Vcore = 1.6V
	LCD_Write_Data(0x0002); //DDVDH = 5.6V

	LCD_Write_Command(0x00CF); //Power Control B
	LCD_Write_Data(0x0000); //always 0x00
	LCD_Write_Data(0x0081); //PCEQ off
	LCD_Write_Data(0x0030); //ESD protection

	LCD_Write_Command(0x00E8); //Driver timing control A
	LCD_Write_Data(0x0085); //non - overlap
	LCD_Write_Data(0x0001); //EQ timing
	LCD_Write_Data(0x0079); //Pre-chargetiming
	LCD_Write_Command(0x00EA); //Driver timing control B
	LCD_Write_Data(0x0000); //Gate driver timing
	LCD_Write_Data(0x0000); //always 0x00
	LCD_Write_Data(0x0064); //soft start 
	LCD_Write_Data(0x0003); //power on sequence 
	LCD_Write_Data(0x0012); //power on sequence 
	LCD_Write_Data(0x0081); //DDVDH enhance on 

	LCD_Write_Command(0x00F7); //Pump ratio control 
	LCD_Write_Data(0x0020); //DDVDH=2xVCI 

	LCD_Write_Command(0x00C0); //power control 1 
	LCD_Write_Data(0x0026);
	LCD_Write_Data(0x0004); //second parameter for ILI9340 (ignored by ILI9341) 

	LCD_Write_Command(0x00C1); //power control 2 
	LCD_Write_Data(0x0011);

	LCD_Write_Command(0x00C5); //VCOM control 1 
	LCD_Write_Data(0x0035);
	LCD_Write_Data(0x003E);

	LCD_Write_Command(0x00C7); //VCOM control 2 
	LCD_Write_Data(0x00BE);

	LCD_Write_Command(0x00B1); //frame rate control 
	LCD_Write_Data(0x0000);
	LCD_Write_Data(0x0010);

	LCD_Write_Command(0x003A); //pixel format = 16 bit per pixel 
	LCD_Write_Data(0x0055);

	LCD_Write_Command(0x00B6); //display function control 
	LCD_Write_Data(0x000A);
	LCD_Write_Data(0x00A2);

	LCD_Write_Command(0x00F2); //3G Gamma control 
	LCD_Write_Data(0x0002); //off 

	LCD_Write_Command(0x0026); //Gamma curve 3 
	LCD_Write_Data(0x0001);

	LCD_Write_Command(0x0036); //memory access control = BGR 
	LCD_Write_Data(0x0000);

	LCD_Write_Command(0x002A); //column address set 
	LCD_Write_Data(0x0000);
	LCD_Write_Data(0x0000); //start 0x0000 
	LCD_Write_Data(0x0000);
	LCD_Write_Data(0x00EF); //end 0x00EF 

	LCD_Write_Command(0x002B); //page address set 
	LCD_Write_Data(0x0000);
	LCD_Write_Data(0x0000); //start 0x0000 
	LCD_Write_Data(0x0001);
	LCD_Write_Data(0x003F); //end 0x013F 
	IOWR_32DIRECT(LCD_CTRL_BASE, LCD_NR_PIX_LINE_REG, 240);
	LCD_width = 240;
	LCD_height = 320;

	LCD_Write_Command(0x0029);
}

void transfer_LCD_no_dma(void *array, int width, int height)
{
	unsigned short *data_array = (unsigned short *)array;
	unsigned int pixels;
	IOWR_32DIRECT(LCD_CTRL_BASE, LCD_Pict_width_reg, width);
	LCD_Write_Command(0x002C); //command to begin writing to frame memory
	for (pixels = 0; pixels < width * height; pixels++)
		LCD_Write_Data(data_array[pixels]);
}

void transfer_LCD_with_dma(void *array, int width, int height, char grayscale)
{
	unsigned short real_height = (height > LCD_height) ? LCD_height : height;
	unsigned short real_width = (width > LCD_width) ? LCD_width : width;
	IOWR_32DIRECT(LCD_CTRL_BASE, LCD_Pict_width_reg, width);
	IOWR_32DIRECT(LCD_CTRL_BASE, LCD_IMAGE_POINTER_REG, (int)array);
	IOWR_32DIRECT(LCD_CTRL_BASE, LCD_IMAGE_SIZE_REG, real_width * real_height);
	if (grayscale == 0)
		IOWR_16DIRECT(LCD_CTRL_BASE, LCD_CONTROL_REG,
			      LCD_Sixteen_Bit | LCD_Start_DMA | LCD_RGB565_Mode | LCD_Color_Image);
	else
		IOWR_16DIRECT(LCD_CTRL_BASE, LCD_CONTROL_REG,
			      LCD_Sixteen_Bit | LCD_Start_DMA | LCD_RGB565_Mode | LCD_GrayScale_Image);
}
