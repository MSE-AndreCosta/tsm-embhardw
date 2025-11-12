/*
 * dipswitch.c
 *
 *  Created on: Sep 12, 2015
 *      Author: theo
 */

#include <system.h>
#include <io.h>

unsigned char DIPSW_get_value()
{
	return IORD_8DIRECT(PIO_0_BASE, 0) ^ 0xFF;
}
