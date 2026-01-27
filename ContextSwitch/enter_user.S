.global enter_user

// void enter_user(void (*entry)(void), uint64_t user_sp)
// x0 = entry, x1 = user_sp
enter_user:

    // Set user stack pointer (SP_EL0)
    msr sp_el0, x1

    // Set exception return address to user entry
    msr elr_el1, x0

    // Return state: EL0t
    mov x2, #0
    msr spsr_el1, x2
    isb

    // Return from exception to EL0
    eret
