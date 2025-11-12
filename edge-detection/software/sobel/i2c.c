/*
 * i2c.c
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#include <system.h>
#include <io.h>
#include "i2c.h"

void i2c_busy_wait()
{
	int busy;
	do {
		busy = IORD_32DIRECT(I2C_CTRL_BASE, I2C_CONTROL_REG);
	} while ((busy & (I2C_Busy_Flag | I2C_Autodetect_Busy_Flag)) != 0);
}

void i2c_auto_detect()
{
	int nrdef, loop, value;
	i2c_busy_wait();
	IOWR_32DIRECT(I2C_CTRL_BASE, I2C_CONTROL_REG, I2C_Autodetect);
	i2c_busy_wait();
	nrdef = IORD_32DIRECT(I2C_CTRL_BASE, I2C_ADDR_REG);
	printf("Number of I2C devices detected: %d\n", nrdef);
	for (loop = 0; loop < nrdef; loop++) {
		IOWR_32DIRECT(I2C_CTRL_BASE, I2C_DEVICE_ID_REG, loop);
		value = IORD_32DIRECT(I2C_CTRL_BASE, I2C_DEVICE_ID_REG);
		printf("Device nr. %d has Address: 0x%02X\n", loop, value);
	}
}

unsigned int i2c_short_read(unsigned char device_id, unsigned short address)
{
	i2c_busy_wait();
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_DEVICE_ID_REG, device_id);
	IOWR_16DIRECT(I2C_CTRL_BASE, I2C_ADDR_REG, address);
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_CONTROL_REG, I2C_2Byte_Transfer | I2C_Start | I2C_Short_Transfer);
	i2c_busy_wait();
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_DEVICE_ID_REG, device_id + 1);
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_CONTROL_REG, I2C_Start | I2C_4Byte_Read);
	i2c_busy_wait();
	return IORD_32DIRECT(I2C_CTRL_BASE, I2C_DATA_REG);
}

void i2c_short_write(unsigned char device_id, unsigned short address, unsigned short data)
{
	i2c_busy_wait();
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_DEVICE_ID_REG, device_id);
	IOWR_16DIRECT(I2C_CTRL_BASE, I2C_ADDR_REG, address);
	IOWR_16DIRECT(I2C_CTRL_BASE, I2C_DATA_REG, data);
	IOWR_8DIRECT(I2C_CTRL_BASE, I2C_CONTROL_REG, I2C_Start | I2C_Short_Transfer);
	i2c_busy_wait();
}
