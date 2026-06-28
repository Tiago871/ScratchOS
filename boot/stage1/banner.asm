; ==========================================
; ScratchOS Banner
; ==========================================

BITS 16

ScrBootBanner:

    mov si, BannerText

    call ScrBootPrintString

    ret


BannerText db "ScratchOS",13,10
           db "ScratchBoot Stage1",13,10
           db "Version 0.1",13,10
           db 0
