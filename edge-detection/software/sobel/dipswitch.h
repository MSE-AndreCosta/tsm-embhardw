/*
 * dipswitch.h
 *
 *  Created on: Sep 12, 2015
 *      Author: theo
 */

#ifndef DIPSWITCH_H_
#define DIPSWITCH_H_

#define DIPSW_SW8_MASK 128
#define DIPSW_SW7_MASK 64
#define DIPSW_SW6_MASK 32
#define DIPSW_SW5_MASK 16
#define DIPSW_SW4_MASK 8
#define DIPSW_SW3_MASK 4
#define DIPSW_SW2_MASK 2
#define DIPSW_SW1_MASK 1

unsigned char DIPSW_get_value();

#endif /* DIPSWITCH_H_ */
