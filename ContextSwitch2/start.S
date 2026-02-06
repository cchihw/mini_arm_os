.global _start
.extern kernel_main
.extern vectors

.section .text
_start:
    // Initialize stack pointer
    ldr x0, =_stack_top
    mov sp, x0

    // Install EL1 exception vector table
    ldr x0, =vectors
    msr vbar_el1, x0
    isb

    // Jump to C kernel entry
    bl kernel_main

1:
    b 1b
