BITS 16
ORG 0x7C00

%include "stage1.inc"

; ==========================================
; ScratchBoot Variables
; ==========================================

BootDrive db 0

; ==========================================
; Entry Point
; ==========================================

start:

    mov [BootDrive], dl

    cli

    call ScrBootBanner

.hang:

    hlt
    jmp .hang

times 510-($-$$) db 0
dw 0xAA55
