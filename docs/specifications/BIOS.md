# ScratchOS BIOS Specification

## Status

Current ScratchBoot implementation uses Legacy BIOS services.

UEFI is not implemented.

## Error Convention

For BIOS routines that perform disk, memory, or A20 operations:

```text
CF = 0  Success
CF = 1  Error
```

## INT 10h — Video Services

### Teletype Output

Purpose:

Print one character in text mode.

Registers:

```text
AH = 0Eh
AL = character
```

ScratchOS routine:

```text
ScrBiosPrintChar
```

Used by:

```text
Stage1 banner output
Stage1 string output
Stage2 string output
Stage2 number output
```

## INT 13h — Disk Services

### Read Sectors

Purpose:

Read Stage2 from disk.

Registers used by the current loader:

```text
AH = 02h
AL = 02h
CH = 00h
CL = 02h
DH = 00h
DL = BIOS boot drive
ES:BX = 0000:7E00
```

Current interpretation:

```text
Cylinder: 0
Head:     0
Start sector: 2
Sector count: 2
```

ScratchOS routine:

```text
ScrBiosReadSector
```

### Reset Disk System

Purpose:

Reset the BIOS disk system for the boot drive.

Registers:

```text
AH = 00h
DL = BIOS boot drive
```

ScratchOS routine:

```text
ScrBiosResetDisk
```

Current status:

```text
Implemented
Not currently called by the normal Stage1 load path
```

## INT 15h — System Services

### E820 Memory Map

Purpose:

Return the BIOS physical-memory map.

Registers:

```text
EAX = E820h
EDX = 534D4150h
ECX = 20
ES:DI = destination buffer
EBX = continuation value
```

ScratchOS routine:

```text
ScrStage2GetMemoryMap
```

Current storage:

```text
Buffer address: 0000:0500
Maximum entries: 16
Entry size: 20 bytes
```

### A20 Enable Request

Purpose:

Request that BIOS enable the A20 line.

Registers:

```text
AX = 2401h
```

ScratchOS routine:

```text
ScrStage2EnableA20
```

Important behavior:

ScratchOS does not assume that the BIOS request alone proves A20 is enabled. It runs a memory-alias verification test afterward.

## Current BIOS Constraints

* The boot path requires Legacy BIOS compatibility.
* The current disk loader uses CHS addressing.
* Stage1 assumes Stage2 begins at disk sector 2.
* Stage1 reads two sectors only.
* The current boot process does not support UEFI.
* The current boot process does not use BIOS filesystem services.
