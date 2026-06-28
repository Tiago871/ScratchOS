; ==========================================
; ScratchOS
; ScratchBoot Stage2
; File: stage2.asm
; ==========================================

BITS 16
ORG 0x7E00

Stage2Start:

    ; TODO:
    ; - Memory detection
    ; - Enable A20
    ; - Setup GDT
    ; - Enter Protected Mode

.hang:

    hlt
    jmp .hang
