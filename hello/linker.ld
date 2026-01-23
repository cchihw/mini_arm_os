ENTRY(_start)

SECTIONS
{
    /* Base address of RAM in QEMU virt machine */
    . = 0x40000000;
    
    /* Increase the location counter by corresponding to the size of the data */
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) *(COMMON) }

    /* Align the stack pointer to 16 bytes */
    . = ALIGN(16);

    /* Reserve 64KB stack space */
    _stack_top = . + 0x10000;
}
