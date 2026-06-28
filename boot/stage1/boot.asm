; ==========================================
; ScratchOS
; ScratchBoot Stage1
; Version 0.1
; ==========================================

BITS 16
ORG 0x7C00

start:

    cli

    mov si, message

.print:

    lodsb              ; AL = kolejny znak

    cmp al, 0
    je hang

    mov ah, 0x0E
    int 0x10

    jmp .print

hang:

    hlt
    jmp hang

message db "ScratchOS", 13,10
        db "ScratchBoot Stage1",13,10
        db "Version 0.1",13,10
        db 0

times 510-($-$$) db 0
dw 0xAA55
