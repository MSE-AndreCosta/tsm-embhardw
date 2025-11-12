/*
 * i2c.h
 *
 *  Created on: Aug 21, 2015
 *      Author: theo
 */

#ifndef I2C_H_
#define I2C_H_

void i2c_auto_detect();
unsigned int i2c_short_read(unsigned char device_id, unsigned short address);
void i2c_short_write(unsigned char device_id, unsigned short address, unsigned short data);

#define I2C_DEVICE_ID_REG	 0
#define I2C_ADDR_REG		 4
#define I2C_DATA_REG		 8
#define I2C_CONTROL_REG		 12
#define I2C_PRESCALE_REG	 13
#define I2C_IRQ_Enable_REG	 14

#define I2C_2Byte_Transfer	 1
#define I2C_3Byte_Transfer	 0
#define I2C_Start		 2
#define I2C_Autodetect		 4
#define I2C_Clear_IRQ		 8
#define I2C_IRQ_enable		 1
#define I2C_4Byte_Read		 (1 << 5)
#define I2C_Short_Transfer	 (1 << 6)

#define I2C_Busy_Flag		 1
#define I2C_Autodetect_Busy_Flag 2

#endif /* I2C_H_ */
