; ==========================================
; ScratchOS
; ScratchBoot Stage2
; File: stage2.asm
; ==========================================

BITS 16
ORG 0x7E00

; ==========================================
; Entry Point
; ==========================================

Stage2Start:

    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7A00

    cld

    sti

    call ScrStage2GetFirstMemoryMapEntry
    jc .memory_error

    mov si, Stage2LoadedMessage
    call ScrStage2PrintString

    mov si, MemoryMapOkMessage
    call ScrStage2PrintString

    jmp .hang

.memory_error:

    mov si, MemoryMapErrorMessage
    call ScrStage2PrintString

.hang:

    cli
    hlt
    jmp .hang


; ------------------------------------------------------
; Function : ScrStage2PrintString
;
; Description:
; Prints a null-terminated string using BIOS INT 10h.
;
; Input:
; DS:SI = address of string
;
; Output:
; String displayed
; ------------------------------------------------------

ScrStage2PrintString:

.print:

    lodsb
    or al, al
    jz .done

    mov ah, 0x0E
    int 0x10

    jmp .print

.done:

    ret


; ------------------------------------------------------
; Function : ScrStage2GetFirstMemoryMapEntry
;
; Description:
; Requests the first BIOS E820 memory-map entry.
;
; Output:
; CF = 0 success
; CF = 1 error
; ------------------------------------------------------

ScrStage2GetFirstMemoryMapEntry:

    xor ebx, ebx

    mov eax, 0x0000E820
    mov ecx, 20
    mov edx, 0x534D4150

    mov di, MemoryMapEntry

    int 0x15
    jc .error

    cmp eax, 0x534D4150
    jne .error

    cmp ecx, 20
    jb .error

    clc
    ret

.error:

    stc
    ret


; ==========================================
; Data
; ==========================================

Stage2LoadedMessage db "ScratchBoot Stage2 Loaded!", 13, 10, 0
MemoryMapOkMessage db "BIOS E820: first memory-map entry read.", 13, 10, 0
MemoryMapErrorMessage db "BIOS E820: unavailable or failed.", 13, 10, 0

; Base address: 8 B
; Length:       8 B
; Type:         4 B
MemoryMapEntry dq 0
               dq 0
               dd 0
