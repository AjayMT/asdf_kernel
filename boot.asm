
global loader                   ; entry symbol for ELF
extern main                     ; silk entry point

    MAGIC_NUMBER equ 0x1BADB002 ; magic constant for multiboot
    FLAGS equ 0x0               ; multiboot flags
    CHECKSUM equ -MAGIC_NUMBER  ; magic number + checksum + flags = 0
    KERNEL_STACK_SIZE equ 4096  ; 4KB stack

section .bss
align 4
kernel_stack:
    resb KERNEL_STACK_SIZE

section .text
align 4
    dd MAGIC_NUMBER
    dd FLAGS
    dd CHECKSUM

loader:
    mov esp, kernel_stack + KERNEL_STACK_SIZE
    call main
.loop:
    jmp .loop
