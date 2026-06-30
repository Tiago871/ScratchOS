; ==========================================
; ScratchOS Constants
; ==========================================

%define SCR_STAGE2_LOAD_SEGMENT    0x0000
%define SCR_STAGE2_LOAD_OFFSET     0x7E00

%define SCR_BOOT_SECTOR            1
%define SCR_STAGE2_SECTOR          2
%define SCR_STAGE2_SECTOR_COUNT    2


; ==========================================
; ScratchOS
; ScratchBoot Stage1
; Common Include File
; ==========================================

%include "bios.asm"
%include "print.asm"
%include "banner.asm"
%include "disk.asm"
