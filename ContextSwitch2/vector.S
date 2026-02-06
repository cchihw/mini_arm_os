.section .text.vectors, "ax"
.align 11                  // 2KB alignment required by VBAR_EL1
.global vectors
vectors:
    // Current EL with SP0
    b sync_current_sp0
    .balign 0x80
    b irq_current_sp0
    .balign 0x80
    b fiq_current_sp0
    .balign 0x80
    b serr_current_sp0
    .balign 0x80

    // Current EL with SPx (SP_EL1)
    b sync_current_spx
    .balign 0x80
    b irq_current_spx
    .balign 0x80
    b fiq_current_spx
    .balign 0x80
    b serr_current_spx
    .balign 0x80

    // Lower EL using AArch64 (this is where EL0 SVC lands)
    b sync_lower_a64
    .balign 0x80
    b irq_lower_a64
    .balign 0x80
    b fiq_lower_a64
    .balign 0x80
    b serr_lower_a64
    .balign 0x80

    // Lower EL using AArch32 (unused)
    b sync_lower_a32
    .balign 0x80
    b irq_lower_a32
    .balign 0x80
    b fiq_lower_a32
    .balign 0x80
    b serr_lower_a32
    .balign 0x80

// --- Default handlers (loop) ---
sync_current_sp0: b .
irq_current_sp0:  b .
fiq_current_sp0:  b .
serr_current_sp0: b .

sync_current_spx: b .
irq_current_spx:  b .
fiq_current_spx:  b .
serr_current_spx: b .

irq_lower_a64:    b .
fiq_lower_a64:    b .
serr_lower_a64:   b .

sync_lower_a32:   b .
irq_lower_a32:    b .
fiq_lower_a32:    b .
serr_lower_a32:   b .

// --- EL0 -> EL1 synchronous handler (SVC/syscall) ---
.extern uart_puts
sync_lower_a64:
    // Save general-purpose registers so we can call C safely.
    // Allocate 272 bytes (17 * 16) to keep SP 16-byte aligned.
    sub sp, sp, #272
    stp x0,  x1,  [sp, #0]
    stp x2,  x3,  [sp, #16]
    stp x4,  x5,  [sp, #32]
    stp x6,  x7,  [sp, #48]
    stp x8,  x9,  [sp, #64]
    stp x10, x11, [sp, #80]
    stp x12, x13, [sp, #96]
    stp x14, x15, [sp, #112]
    stp x16, x17, [sp, #128]
    stp x18, x19, [sp, #144]
    stp x20, x21, [sp, #160]
    stp x22, x23, [sp, #176]
    stp x24, x25, [sp, #192]
    stp x26, x27, [sp, #208]
    stp x28, x29, [sp, #224]
    stp x30, xzr, [sp, #240]

    // Minimal demo: treat all EL0 sync exceptions as "syscall".
    // (Later you can read ESR_EL1 here to distinguish SVC vs faults.)
    ldr x0, =msg_kernel_svc
    bl uart_puts

    // Restore registers
    ldp x30, xzr, [sp, #240]
    ldp x28, x29, [sp, #224]
    ldp x26, x27, [sp, #208]
    ldp x24, x25, [sp, #192]
    ldp x22, x23, [sp, #176]
    ldp x20, x21, [sp, #160]
    ldp x18, x19, [sp, #144]
    ldp x16, x17, [sp, #128]
    ldp x14, x15, [sp, #112]
    ldp x12, x13, [sp, #96]
    ldp x10, x11, [sp, #80]
    ldp x8,  x9,  [sp, #64]
    ldp x6,  x7,  [sp, #48]
    ldp x4,  x5,  [sp, #32]
    ldp x2,  x3,  [sp, #16]
    ldp x0,  x1,  [sp, #0]
    add sp, sp, #272

    // Return to EL0 at ELR_EL1 with PSTATE restored from SPSR_EL1
    eret

.section .rodata
msg_kernel_svc:
    .asciz "kernel: in syscall (SVC)\n"
