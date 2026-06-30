# ScratchOS Memory Map

## Status

This document describes memory ownership during the current 16-bit real-mode boot stage.

The map will be expanded when ScratchOS enters Protected Mode and later Long Mode.

## Real-Mode Memory Layout

| Address Range      | Owner or Purpose                 | Notes                                                                                      |
| ------------------ | -------------------------------- | ------------------------------------------------------------------------------------------ |
| `0x00000–0x003FF`  | Interrupt Vector Table           | Owned by BIOS. ScratchOS must not overwrite it.                                            |
| `0x00400–0x004FF`  | BIOS Data Area                   | Owned by BIOS. ScratchOS must not overwrite it.                                            |
| `0x00500–0x0063F`  | E820 memory-map buffer           | Holds up to 16 entries × 20 bytes.                                                         |
| `0x00700`          | A20 low-memory test byte         | Temporarily modified and restored during A20 verification.                                 |
| `0x00701–0x079FF`  | Temporary low memory             | Not permanently owned by ScratchBoot. Avoid using without an explicit allocation decision. |
| `0x07A00` downward | Stage2 stack                     | Initial stack pointer is `0000:7A00`; stack grows downward.                                |
| `0x07C00–0x07DFF`  | ScratchBoot Stage1               | BIOS boot sector, exactly 512 bytes.                                                       |
| `0x07E00–0x081FF`  | ScratchBoot Stage2 load region   | Two sectors, maximum 1024 bytes.                                                           |
| `0x08200–0x9FFFF`  | Unreserved by ScratchBoot        | Actual usability must be determined from E820.                                             |
| `0xA0000–0xFFFFF`  | Video memory, ROM, BIOS regions  | Do not treat as general RAM.                                                               |
| `0x100700`         | A20 high-memory test byte        | Temporarily modified and restored during A20 verification.                                 |
| `Above 0x100000`   | Physical memory reported by E820 | Availability depends on BIOS E820 entries.                                                 |

## Stage1

```text
Load address: 0000:7C00
Size:         512 bytes
```

Stage1 must remain exactly one sector long and end with the BIOS boot signature:

```text
0xAA55
```

## Stage2

```text
Load address: 0000:7E00
Maximum size: 1024 bytes
Loaded sectors: 2 and 3
```

Stage2 must not exceed 1024 bytes while Stage1 reads only two sectors.

## E820 Buffer

Stage2 stores E820 entries in low memory:

```text
Address:         0000:0500
Maximum entries: 16
Entry size:      20 bytes
Total size:      320 bytes
End address:     0000:063F
```

Each entry contains:

```text
Base address: 8 bytes
Length:       8 bytes
Type:         4 bytes
```

## A20 Test Memory

A20 verification compares these two locations:

```text
0000:0700
FFFF:0710
```

The second address resolves to physical address:

```text
0x100700
```

ScratchOS saves and restores the original bytes at both addresses.

## Stack Rules

Stage2 initializes:

```text
SS = 0000
SP = 7A00
```

The stack grows downward.

Future code must avoid placing persistent data directly below `0x07A00` unless stack limits are explicitly redesigned.

## Protected Mode

Not implemented yet.

Planned additions:

```text
GDT
32-bit code and data segments
Protected-mode stack
Physical memory manager
Paging structures
```

## Long Mode

Not implemented yet.

Planned additions:

```text
Page tables
64-bit code and data execution
Higher-level kernel memory map
ScratchKernel handoff data
```
