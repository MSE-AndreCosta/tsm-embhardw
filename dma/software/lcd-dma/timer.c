
#include "system.h"
#include "timer.h"
#include "io.h"
volatile uint32_t counter;

static void timer_isr(void *context, alt_u32 id);

static void timer_isr(void *context, alt_u32 id)
{
	counter++;
	IOWR_32DIRECT(PARALLEL_PORT_0_BASE, 0x8, counter);
	IOWR_16DIRECT(TIMER_0_BASE, 0, 0x0);
}
void timer_init(void)
{
	alt_irq_register(TIMER_0_IRQ, (void *)2, timer_isr);

	IOWR_16DIRECT(TIMER_0_BASE, 4, 0x7);
}
uint32_t timer_get_tick(void)
{
	return counter;
}
