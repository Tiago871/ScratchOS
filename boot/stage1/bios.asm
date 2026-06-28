; ==========================================
; ScratchOS
; BIOS Interface
; Version 0.1
; ==========================================

BITS 16

; ------------------------------------------
; ScrBiosPrintChar
;
; IN:
;   AL = ASCII character
;
; OUT:
;   Character printed on screen
; ------------------------------------------

ScrBiosPrintChar:

    mov ah, 0x0E
    int 0x10

    ret
