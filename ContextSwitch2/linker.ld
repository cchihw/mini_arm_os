ENTRY(_start)

SECTIONS
{
    /* Base address of RAM in QEMU virt machine */
    . = 0x40000000;

    .text : {
        KEEP(*(.text.vectors))
        *(.text*) 
    }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) *(COMMON) }

    . = ALIGN(16);

    /* Reserve 64KB stack space for the boot CPU (EL1 stack) */
    _stack_top = . + 0x10000;
}
