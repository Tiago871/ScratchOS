; ==========================================
; ScratchOS
; ScratchBoot Stage2
; File: stage2.asm
; ==========================================

BITS 16
ORG 0x7E00

; ==========================================
; Entry Point
; ==========================================

Stage2Start:

    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7A00

    cld

    sti

    mov si, Stage2Message

.print:

    lodsb
    or al, al
    jz .done

    mov ah, 0x0E
    int 0x10

    jmp .print

.done:

.hang:

    cli
    hlt
    jmp .hang

; ==========================================
; Data
; ==========================================

Stage2Message db "ScratchBoot Stage2 Loaded!", 0
