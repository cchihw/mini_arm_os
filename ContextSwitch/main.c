#include <stdint.h>
#include "uart.h"

extern void enter_user(void (*entry)(void), uint64_t user_sp);

static unsigned long read_currentel(void)
{
    unsigned long v;
    asm volatile("mrs %0, CurrentEL" : "=r"(v));
    return v;
}

__attribute__((noreturn))
static void user_main(void){
    uart_puts("user: hello\n");
    while (1) {
    }
}

static uint8_t user_stack[4096] __attribute__((aligned(16)));

void kernel_main(void){
    uart_init();
    uart_puts("kernel: before switch\n");
    read_currentel(); // for debug
    uint64_t sp = (uint64_t)(user_stack + sizeof(user_stack));
    sp &= ~0xFULL;

    enter_user(user_main, sp);

    while (1) {
        asm volatile("wfe");
    }
}
