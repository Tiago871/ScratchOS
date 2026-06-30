; ==========================================
; ScratchOS
; BIOS Library
; File: bios.asm
; ==========================================

BITS 16

; ------------------------------------------------------
; Function : ScrBiosPrintChar
;
; Description:
; Prints one character using BIOS INT 10h.
;
; Input:
; AL = character
;
; Output:
; Character displayed
; ------------------------------------------------------

ScrBiosPrintChar:

    mov ah,0x0E
    int 0x10

    ret


; ------------------------------------------------------
; Function : ScrBiosReadSector
;
; Description:
; Reads Stage2 sectors from disk into memory.
; ------------------------------------------------------

ScrBiosReadSector:

    pusha

    xor ax, ax
    mov es, ax

    mov bx, SCR_STAGE2_LOAD_OFFSET

    mov ah, 0x02
        mov al, SCR_STAGE2_SECTOR_COUNT

    mov ch, 0x00
    mov cl, SCR_STAGE2_SECTOR
    mov dh, 0x00

    mov dl, [BootDrive]

    int 0x13

    popa
    ret


; ------------------------------------------------------
; Function : ScrBiosResetDisk
;
; Description:
; Resets the disk controller using BIOS.
;
; Input:
; DL = Boot drive
;
; Output:
; CF = 0 success
; CF = 1 error
;
; Status:
; Stable
; ------------------------------------------------------

ScrBiosResetDisk:

    pusha

    mov ah, 0x00
    mov dl, [BootDrive]

    int 0x13

    popa
    ret




; ------------------------------------------------------
; BIOS Disk Services (INT 13h)
;
; Functions:
;   ScrBiosReadSector
;   ScrBiosResetDisk
;
; ------------------------------------------------------
