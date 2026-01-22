#define UART_BASE 0x09000000UL

#define UART_DR (*(volatile unsigned int *)(UART_BASE + 0x00))
#define UART_FR (*(volatile unsigned int *)(UART_BASE + 0x18))

static void uart_putc(char c)
{
    // Wait until TX FIFO is not full (FR bit5 = TXFF)
    while (UART_FR & (1u << 5)) {
    }
    UART_DR = (unsigned int)c;
}

static void uart_puts(const char *s)
{
    while (*s) {
        // Convert LF to CRLF for terminal compatibility
        if (*s == '\n') {
            uart_putc('\r');
        }
        uart_putc(*s++);
    }
}

void kernel_main(void)
{
    uart_puts("Hello, OS!\n");

    // Enter low-power wait loop
    while (1) {
        asm volatile("wfe");
    }
}
