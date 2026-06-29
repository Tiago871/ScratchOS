; ==========================================
; ScratchOS
; ScratchBoot Stage2
; File: stage2.asm
; ==========================================

BITS 16
ORG 0x7E00

; ==========================================
; Constants
; ==========================================

SCR_E820_SIGNATURE         equ 0x534D4150
SCR_E820_FUNCTION          equ 0xE820
SCR_E820_ENTRY_SIZE        equ 20
SCR_E820_MAX_ENTRIES       equ 16
SCR_MEMORY_MAP_BUFFER      equ 0x0500

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

    mov si, Stage2LoadedMessage
    call ScrStage2PrintString

    call ScrStage2GetMemoryMap
    jc .memory_error

    mov si, MemoryMapOkMessage
    call ScrStage2PrintString

    mov ax, [MemoryMapEntryCount]
    call ScrStage2PrintNumber

    mov si, NewLineMessage
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
; Function : ScrStage2PrintNumber
;
; Description:
; Prints an unsigned decimal number.
;
; Input:
; AX = number
;
; Output:
; Number displayed
; ------------------------------------------------------

ScrStage2PrintNumber:

    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    mov bx, 10

.divide:

    xor dx, dx
    div bx

    push dx
    inc cx

    test ax, ax
    jnz .divide

.print:

    pop dx

    add dl, '0'

    mov al, dl
    mov ah, 0x0E

    push cx
    int 0x10
    pop cx

    loop .print

    pop dx
    pop cx
    pop bx
    pop ax

    ret

; ------------------------------------------------------
; Function : ScrStage2GetMemoryMap
;
; Description:
; Reads BIOS E820 memory-map entries into low memory.
;
; Output:
; CF = 0 success
; CF = 1 error or buffer full
;
; Notes:
; Entries are stored at 0000:0500.
; One entry uses 20 bytes.
; ------------------------------------------------------

ScrStage2GetMemoryMap:

    mov word [MemoryMapEntryCount], 0
    mov word [MemoryMapWriteOffset], SCR_MEMORY_MAP_BUFFER

    xor ebx, ebx

.next_entry:

    mov eax, SCR_E820_FUNCTION
    mov ecx, SCR_E820_ENTRY_SIZE
    mov edx, SCR_E820_SIGNATURE

    mov di, [MemoryMapWriteOffset]

    int 0x15
    jc .error

    cmp eax, SCR_E820_SIGNATURE
    jne .error

    cmp ecx, SCR_E820_ENTRY_SIZE
    jb .error

    ; Ignore entries with zero length.

    cmp dword [di + 8], 0
    jne .store_entry

    cmp dword [di + 12], 0
    je .continue

.store_entry:

    inc word [MemoryMapEntryCount]
    add word [MemoryMapWriteOffset], SCR_E820_ENTRY_SIZE

    cmp word [MemoryMapEntryCount], SCR_E820_MAX_ENTRIES
    jae .check_end

.continue:

    test ebx, ebx
    jnz .next_entry

    clc
    ret

.check_end:

    test ebx, ebx
    jz .success

    jmp .error

.success:

    clc
    ret

.error:

    stc
    ret


; ==========================================
; Data
; ==========================================

Stage2LoadedMessage db "ScratchBoot Stage2 Loaded!", 13, 10, 0
MemoryMapOkMessage db "BIOS E820 entries: ", 0
NewLineMessage     db 13, 10, 0
MemoryMapErrorMessage db "BIOS E820: failed or buffer full.", 13, 10, 0

MemoryMapEntryCount  dw 0
MemoryMapWriteOffset dw SCR_MEMORY_MAP_BUFFER
