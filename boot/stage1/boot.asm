BITS 16
ORG 0x7C00

jmp start

%include "stage1.inc"

; ==========================================
; ScratchBoot Variables
; ==========================================

BootDrive db 0

; ==========================================
; Entry Point
; ==========================================

start:

    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    sti

    mov [BootDrive], dl

    call ScrBootBanner

    call ScrBiosReadSector
    jc .disk_error

    jmp 0x0000:SCR_STAGE2_LOAD_OFFSET

.disk_error:

    mov si, DiskErrorMessage
    call ScrBootPrintString

.hang:

    cli
    hlt
    jmp .hang

DiskErrorMessage db 13, 10, "Disk read error", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
