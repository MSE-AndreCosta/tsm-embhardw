/*
 * camera.c
 *
 *  Created on: Aug 24, 2015
 *      Author: theo
 */

#include <system.h>
#include <io.h>
#include <stdio.h>
#include "i2c.h"
#include "camera.h"
#include "mt9d112.h"

void init_camera()
{
	int i;
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_PRESCALE_REG, 2); // Set prescaler
	IOWR_8DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG, CAM_Reset);
	for (i = 0; i < 1000000; i++)
		asm volatile("nop");
	IOWR_8DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG, 0);
	for (i = 0; i < 1000000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_MCU_BOOT, 0x0001);
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_MCU_BOOT, 0x0000);
	for (i = 0; i < 1000000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_SENSOR_RESET, 0x00C4);
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_STANDBY_CONTROL, 0x0008);
	i2c_short_write(CAM_I2C_ID, 0x33F4, 0x031D);
	for (i = 0; i < 100000; i++)
		asm volatile("nop");
	/* enable PLL */
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_PLL_CLK_IN_CONTROL, 0x8F09);
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_PLL_DIVIDERS_1, 0x0150);
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_PLL_CLK_IN_CONTROL, 0x8F09);
	for (i = 0; i < 100000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, REG_MT9D112_PLL_CLK_IN_CONTROL, 0x8F08);
	/* Set regs */
	for (i = 0; i < (sizeof(preview_snapshot_mode_reg_settings_array) / 4); i++) {
		i2c_short_write(CAM_I2C_ID, preview_snapshot_mode_reg_settings_array[i][0],
				preview_snapshot_mode_reg_settings_array[i][1]);
	}
	for (i = 0; i < (sizeof(noise_reduction_reg_settings_array) / 4); i++) {
		i2c_short_write(CAM_I2C_ID, noise_reduction_reg_settings_array[i][0], noise_reduction_reg_settings_array[i][1]);
	}
	i2c_short_write(CAM_I2C_ID, 0x35A4, 0x0593);
	// sequencer table
	i2c_short_write(CAM_I2C_ID, 0x338C, 0x2799);
	i2c_short_write(CAM_I2C_ID, 0x3390, 0x6440);
	for (i = 0; i < 100000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, 0x338C, 0x279B);
	i2c_short_write(CAM_I2C_ID, 0x3390, 0x6440);
	for (i = 0; i < 100000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, 0x338C, 0xA103);
	i2c_short_write(CAM_I2C_ID, 0x3390, 0x0005);
	for (i = 0; i < 100000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, 0x338C, 0xA103);
	i2c_short_write(CAM_I2C_ID, 0x3390, 0x0006);
	for (i = 0; i < 100000; i++)
		asm volatile("nop");
	for (i = 0; i < (sizeof(lens_roll_off_tbl) / 4); i++) {
		i2c_short_write(CAM_I2C_ID, lens_roll_off_tbl[i][0], lens_roll_off_tbl[i][1]);
	}
	for (i = 0; i < 1000000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, 0x332E, 0x0020);
	for (i = 0; i < 1000000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, 0x3404, 0x0022); /* set RGB565 mode */
	for (i = 0; i < 1000000; i++)
		asm volatile("nop");
	i2c_short_write(CAM_I2C_ID, 0x3040, 0x0027); /* mirror */
}

unsigned short cam_get_xsize()
{
	unsigned char control_reg;
	do {
		control_reg = IORD_8DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG);
	} while ((control_reg & CAM_Profile_valid) == 0);
	return IORD_16DIRECT(CAM_CTRL_BASE, CAM_BYTES_EACH_LINE_REG);
}

unsigned short cam_get_ysize()
{
	unsigned char control_reg;
	do {
		control_reg = IORD_8DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG);
	} while ((control_reg & CAM_Profile_valid) == 0);
	return IORD_16DIRECT(CAM_CTRL_BASE, CAM_LINES_EACH_FRAME_REG);
}

void cam_get_profiling()
{
	unsigned char control_reg;
	do {
		control_reg = IORD_8DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG);
	} while ((control_reg & CAM_Profile_valid) == 0);
	printf("Nr. of bytes each line    : %d\n", IORD_16DIRECT(CAM_CTRL_BASE, CAM_BYTES_EACH_LINE_REG));
	printf("Nr. of lines each frame   : %d\n", IORD_16DIRECT(CAM_CTRL_BASE, CAM_LINES_EACH_FRAME_REG));
	printf("Nr. of frames each second : %d\n", IORD_16DIRECT(CAM_CTRL_BASE, CAM_FRAME_RATE_REG));
}

void cam_set_image_pointer(char pointer_id, void *memory_pointer)
{
	switch (pointer_id) {
	case 0:
		IOWR_32DIRECT(CAM_CTRL_BASE, CAM_ADDR_PNTR_1, (int)memory_pointer);
		break;
	case 1:
		IOWR_32DIRECT(CAM_CTRL_BASE, CAM_ADDR_PNTR_2, (int)memory_pointer);
		break;
	case 2:
		IOWR_32DIRECT(CAM_CTRL_BASE, CAM_ADDR_PNTR_3, (int)memory_pointer);
		break;
	case 3:
		IOWR_32DIRECT(CAM_CTRL_BASE, CAM_ADDR_PNTR_4, (int)memory_pointer);
		break;
	default:
		return;
	}
}

short current_image_valid()
{
	unsigned short value;
	value = IORD_16DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG);
	return (value & CAM_Current_Image_Valid);
}

void *current_image_pointer()
{
	return (void *)IORD_32DIRECT(CAM_CTRL_BASE, CAM_ADDR_PNTR_1);
}

void take_picture_blocking()
{
	unsigned short value;
	IOWR_16DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG, CAM_Take_Picture);
	do {
		value = IORD_16DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG);
	} while ((value & CAM_Busy) != 0);
}

void enable_continues_mode()
{
	IOWR_16DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG, CAM_Start_Continues);
}

char new_image_available()
{
	unsigned short value;
	value = IORD_16DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG);
	if ((value & CAM_IRQ_Generated) != 0) {
		IOWR_16DIRECT(CAM_CTRL_BASE, CAM_CONTROL_REG, CAM_Clear_IRQ);
		return 1;
	} else
		return 0;
}
