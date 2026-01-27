.global _start
.extern kernel_main

.section .text
_start:
    // Initialize stack pointer
    ldr x0, =_stack_top
    mov sp, x0

    // Jump to C kernel entry
    bl kernel_main

1:
    // Hang if kernel_main returns
    b 1b
