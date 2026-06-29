; ==========================================
; ScratchOS
; ScratchBoot Stage2
; File: stage2.asm
; ==========================================

BITS 16
ORG 0x7E00

Stage2Start:

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

    hlt
    jmp .hang

; ------------------------------------------

Stage2Message db "ScratchBoot Stage2 Loaded!", 0
