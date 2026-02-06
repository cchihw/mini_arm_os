#include <stdint.h>
#include "uart.h"

extern void enter_user(void (*entry)(void), uint64_t user_sp);

static inline void syscall0(void)
{
    asm volatile("svc #0" ::: "memory");
}

__attribute__((noreturn))
static void user_main(void){
    uart_puts("user: before syscall\n");
    syscall0();
    uart_puts("user: after syscall\n");
    while (1) {
        asm volatile("wfe");
    }
}

static uint8_t user_stack[4096] __attribute__((aligned(16)));

void kernel_main(void){
    uart_init();
    uart_puts("kernel: before switch\n");

    uint64_t sp = (uint64_t)(user_stack + sizeof(user_stack));
    sp &= ~0xFULL;

    enter_user(user_main, sp);

    uart_puts("kernel: ERROR: returned from enter_user\n");
    while (1) {
        asm volatile("wfe");
    }
}
