/*
 * Arch specific code for Realtek based boards
 *
 * Copyright (C) 2023 Andreas Böhler <dev@aboehler.at>
 * Based on Code from ZyXEL/Realtek U-Boot
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#include <stddef.h>
#include "config.h"

#define UART_BASE_ADDR (0xb8002000)

//#define KSEG1ADDR(_x)		(((_x) & 0x1fffffff) | 0xa0000000)

void board_putc(int ch)
{
	while ((*((volatile unsigned int *)(UART_BASE_ADDR+0x14)) & 0x20000000) == 0);
	*((volatile unsigned char *)UART_BASE_ADDR) = ch;
}

#if (CONFIG_ZYNOS_DUAL_IMAGE)
char board_getc(void)
{
	while ((*((volatile unsigned int *)(UART_BASE_ADDR+0x14)) & 0x8F000000) != 0x01000000);
	return 	*((volatile unsigned char *)UART_BASE_ADDR);
}

int board_peek(void) {
	/* 0x8F = 1000 1111. I.e., Check RFE, FE, PE, OE and DR bits. Only DR should be 1.
	   Otherwise, there is an error. */
	return ((*((volatile unsigned int *)(UART_BASE_ADDR+0x14)) & 0x8F000000) == 0x01000000);
}

void __delay(unsigned long loops)
{
	__asm__ __volatile__ (
	"	.set	noreorder				\n"
	"	.align	3					\n"
	"1:	bnez	%0, 1b					\n"
	"	subu	%0, %1		\n"
	"	.set	reorder					\n"
	: "=r" (loops)
	: "I" (1), "0" (loops));
}

void board_udelay(unsigned long us)
{
	const unsigned int lpj = 432;

	__delay((us * 0x000010c7ull * 100 * lpj) >> 32);
}

#endif

void board_init(void)
{
}
