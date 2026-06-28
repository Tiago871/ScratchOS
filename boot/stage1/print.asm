; ==========================================
; ScratchOS
; Print Library
; Version 0.1
; ==========================================

BITS 16

; --------------------------------------------------
; Function:
;     ScrBootPrintString
;
; Description:
;     Prints a null-terminated string.
;
; Input:
;     DS:SI -> string
;
; Output:
;     String displayed
; --------------------------------------------------

ScrBootPrintString:

.next:

    lodsb

    cmp al,0
    je .done

    mov ah,0x0E
    int 0x10

    jmp .next

.done:

    ret
