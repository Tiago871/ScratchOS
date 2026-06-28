BITS 16
ORG 0x7C00

%include "bios.asm"
%include "print.asm"
%include "banner.asm"

start:

    cli

    call ScrBootBanner

hang:

    hlt
    jmp hang

times 510-($-$$) db 0
dw 0xAA55
