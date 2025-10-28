

#include "lcd.h"
#include "system.h"
#include "io.h"
#include "timer.h"
#include <stdint.h>
#include <stdio.h>

#define LCD_DEVICE_ID_OFFSET	  0x0
#define LCD_DEVICE_ID		  0x1234cafe
#define LCD_TEST_REGISTER_OFFSET  0x4
#define LCD_COMMAND_OFFSET	  0x8
#define LCD_DATA_OFFSET		  0xC
#define LCD_BUFFER_ADDRESS_OFFSET 0x10
#define LCD_BUFFER_SIZE_OFFSET	  0x14
#define LCD_CONTROL_OFFSET	  0x18
#define LCD_CS_CONTROL_OFFSET	  0x1C

#define LCD_CONTROL_START_DMA	  0x1
#define LCD_CONTROL_EN_IRQ	  0x2
#define LCD_CONTROL_ACK_IRQ	  0x4

#define LCD_IM0_MASK		  0x20
#define LCD_NRESET_MASK		  0x40

#if LCD_DMA_CONTROLLER_0_IRQ == -1
#warning LCD_DMA_CONTROLLER_0_IRQ == -1
#undef LCD_DMA_CONTROLLER_0_IRQ
#define LCD_DMA_CONTROLLER_0_IRQ 2
#endif

static void lcd_write_data(uint16_t data);
static void lcd_write_cmd(uint16_t cmd);

static inline void lcd_write_cmd(uint16_t cmd)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_COMMAND_OFFSET, cmd);
}

static inline void lcd_write_data(uint16_t data)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_DATA_OFFSET, data);
}

static inline void lcd_turn_off(void)
{
	/* nReset = 0 IM0 = 0 (16 bit mode)*/
	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x2, 0);
}

static inline void lcd_turn_on(void)
{
	/* nReset = 1  IM0 = 0 (16 bit mode) */
	IOWR_8DIRECT(PARALLEL_PORT_1_BASE, 0x2, LCD_NRESET_MASK);
}

void lcd_select(void)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_CS_CONTROL_OFFSET, 1);
}

void lcd_unselect(void)
{
	/* nReset = 1 IM0 = 1 (16 bit mode) nCS = 1 */
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_CS_CONTROL_OFFSET, 0);
}
void lcd_set_buffer_address(uint32_t address)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_BUFFER_ADDRESS_OFFSET, address);
}

void lcd_set_buffer_size(uint32_t size)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_BUFFER_SIZE_OFFSET, size);
}

void lcd_start_dma_transfer(void)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_CONTROL_OFFSET, LCD_CONTROL_EN_IRQ | LCD_CONTROL_START_DMA);
}

static void lcd_ack_transfer(void)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_CONTROL_OFFSET, LCD_CONTROL_EN_IRQ | LCD_CONTROL_ACK_IRQ);
}

void lcd_enable_irq(void)
{
	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_CONTROL_OFFSET, LCD_CONTROL_EN_IRQ);
}

void lcd_init(void)
{
	uint32_t device_id = IORD_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_DEVICE_ID_OFFSET);

	if (device_id != LCD_DEVICE_ID) {
		printf("Invalid device id. Expected %#lx Got %#lx", LCD_DEVICE_ID, device_id);
		while (1)
			;
	}
	uint32_t tick = timer_get_tick();

	IOWR_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_TEST_REGISTER_OFFSET, tick);
	uint32_t test_tick = IORD_32DIRECT(LCD_DMA_CONTROLLER_0_BASE, LCD_TEST_REGISTER_OFFSET);

	if (tick != test_tick) {
		printf("Failed to write a value to the LCD interface\n");
		while (1)
			;
	}

	lcd_turn_off();
	tick = timer_get_tick();
	while (timer_get_tick() - tick < 120)
		;

	lcd_turn_on();

	lcd_select();
	tick = timer_get_tick();
	while (timer_get_tick() - tick < 120)
		;

	/* Display OFF */
	lcd_write_cmd(0x0028);
	/* exit SLEEP mode */
	lcd_write_cmd(0x0011);
	lcd_write_data(0x0000);
	/* Power Control A */
	lcd_write_data(0x0039); /* always 0x39 */
	lcd_write_data(0x002C); /* always 0x2C */
	lcd_write_data(0x0000); /* always 0x00 */
	lcd_write_data(0x0034); /* Vcore = 1.6V */
	lcd_write_data(0x0002); /* DDVDH = 5.6V */
	/* Power Control B */
	lcd_write_cmd(0x00CF);
	lcd_write_data(0x0000); /* always 0x00 */
	lcd_write_data(0x0081); /* PCEQ off */
	lcd_write_data(0x0030); /* ESD protection */
	/* Driver timing control A */
	lcd_write_cmd(0x00E8);
	lcd_write_data(0x0085); /* non-overlap */
	lcd_write_data(0x0001); /* EQ timing */
	lcd_write_data(0x0079); /* Pre-charge timing */
	/* Driver timing control B */
	lcd_write_cmd(0x00EA);
	lcd_write_data(0x0000); /* Gate driver timing */
	lcd_write_data(0x0000); /* always 0x00 */
	/* Power-On sequence control */
	lcd_write_cmd(0x00ED);
	lcd_write_data(0x0064); /* soft start */
	lcd_write_data(0x0003); /* power on sequence */
	lcd_write_data(0x0012); /* power on sequence */
	lcd_write_data(0x0081); /* DDVDH enhance on */
	/* Pump ratio control */
	lcd_write_cmd(0x00F7);
	lcd_write_data(0x0020); /* DDVDH=2xVCI */
	/* Power control 1 */
	lcd_write_cmd(0x00C0);
	lcd_write_data(0x0026);
	lcd_write_data(0x0004); /* second parameter for ILI9340 (ignored by ILI9341) */
	/* Power control 2 */
	lcd_write_cmd(0x00C1);
	lcd_write_data(0x0011);
	/* VCOM control 1 */
	lcd_write_cmd(0x00C5);
	lcd_write_data(0x0035);
	lcd_write_data(0x003E);
	/* VCOM control 2 */
	lcd_write_cmd(0x00C7);
	lcd_write_data(0x00BE);
	/* Frame rate control */
	lcd_write_cmd(0x00B1);
	lcd_write_data(0x0000);
	lcd_write_data(0x0010);
	/* Pixel format = 16 bit per pixel */
	lcd_write_cmd(0x003A);
	lcd_write_data(0x0055);
	/* Display function control */
	lcd_write_cmd(0x00B6);
	lcd_write_data(0x000A);
	lcd_write_data(0x00A2);
	/* 3G Gamma control */
	lcd_write_cmd(0x00F2);
	lcd_write_data(0x0002); /* off */
	/* Gamma curve 3 */
	lcd_write_cmd(0x0026);
	lcd_write_data(0x0001);
	/* Memory access control = BGR */
	lcd_write_cmd(0x0036);
	lcd_write_data(0x0000);
	/* Column address set */
	lcd_write_cmd(0x002A);
	lcd_write_data(0x0000);
	lcd_write_data(0x0000); /* start 0x0000 */
	lcd_write_data(0x0000);
	lcd_write_data(0x00EF); /* end 0x00EF */
	/* Page address set */
	lcd_write_cmd(0x002B);
	lcd_write_data(0x0000);
	lcd_write_data(0x0000); /* start 0x0000 */
	lcd_write_data(0x0001);
	lcd_write_data(0x003F); /* end 0x013F */

	/* Display ON */
	lcd_write_cmd(0x0029);
	lcd_unselect();

	lcd_enable_irq();
}

void lcd_write(const uint16_t *buffer, uint32_t size)
{
	lcd_write_cmd(0x002c);
	lcd_set_buffer_address((uint32_t)buffer);
	lcd_set_buffer_size(size);
	//lcd_start_dma_transfer();
//
//	for (uint32_t i = 0; i < size / 2; ++i) {
//		lcd_write_data(buffer[i]);
//	}
}
