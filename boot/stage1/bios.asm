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
; Reads one sector from disk.
;
; Input:
; (to be defined)
;
; Output:
; Sector loaded into memory.
;
; Status:
; TODO
; ------------------------------------------------------

ScrBiosReadSector:

    ret





; ------------------------------------------------------
; BIOS Disk Services (INT 13h)
;
; Functions:
;   ScrBiosReadSector
;   ScrBiosResetDisk
;
; ------------------------------------------------------
