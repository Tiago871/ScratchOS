# ScratchBoot API

## Version

0.1

## Scope

This document describes the current internal source-level routines used by ScratchBoot.

This is not yet a stable binary ABI. Function names, calling conventions, and data structures may change while the bootloader is being developed.

## Naming Convention

ScratchOS uses function prefixes to show subsystem ownership.

```text
ScrBoot...    Generic Stage1 boot routines
ScrBios...    BIOS service wrappers
ScrStage2...  Stage2 loader routines
```

Examples:

```text
ScrBootBanner
ScrBootPrintString
ScrBiosReadSector
ScrStage2GetMemoryMap
ScrStage2EnableA20
```

## Design Rules

* One function should have one responsibility.
* Shared functionality should not be duplicated.
* Stage1 must remain as small as possible.
* Stage2 routines must preserve the assumptions stated in their comments.
* BIOS errors are reported through the Carry Flag where documented.
* Stage2 must remain within the currently loaded 1024-byte region.

# Stage1 Routines

## ScrBootBanner

Description:

Displays the Stage1 ScratchOS startup banner.

Input:

```text
None
```

Output:

```text
Banner displayed through BIOS text output.
```

## ScrBootPrintString

Description:

Prints a null-terminated string.

Input:

```text
DS:SI = address of null-terminated string
```

Output:

```text
String displayed.
```

## ScrBiosPrintChar

Description:

Prints one character using BIOS text output.

BIOS service:

```text
INT 10h
AH = 0Eh
```

Input:

```text
AL = character
```

Output:

```text
Character displayed.
```

## ScrBiosReadSector

Description:

Loads Stage2 sectors from the boot drive into memory.

Current operation:

```text
Read start sector: 2
Read count:        2 sectors
Destination:       0000:7E00
```

Input:

```text
Uses BootDrive stored by Stage1.
```

Output:

```text
CF = 0  Read succeeded
CF = 1  BIOS disk read failed
```

## ScrBiosResetDisk

Description:

Requests a reset of the current BIOS boot drive.

BIOS service:

```text
INT 13h
AH = 00h
```

Input:

```text
Uses BootDrive stored by Stage1.
```

Output:

```text
CF = 0  Reset succeeded
CF = 1  BIOS reset failed
```

Current status:

```text
Implemented
Not currently used by the Stage1 loading path
```

# Stage2 Routines

## ScrStage2PrintString

Description:

Prints a null-terminated string through BIOS text output.

Input:

```text
DS:SI = address of null-terminated string
```

Output:

```text
String displayed.
```

## ScrStage2PrintNumber

Description:

Prints an unsigned decimal number.

Input:

```text
AX = unsigned number
```

Output:

```text
Decimal representation displayed.
```

## ScrStage2GetMemoryMap

Description:

Collects BIOS E820 memory-map entries.

Output:

```text
CF = 0  Memory map collected
CF = 1  BIOS error, invalid response, or buffer limit reached
```

Memory output:

```text
Buffer:          0000:0500
Maximum entries: 16
Entry size:      20 bytes
Count variable:  MemoryMapEntryCount
```

## ScrStage2EnableA20

Description:

Ensures that the A20 line is enabled.

Behavior:

```text
1. Tests current A20 state.
2. Returns success if A20 is already enabled.
3. Uses BIOS INT 15h / AX=2401h if A20 is disabled.
4. Tests A20 again.
```

Output:

```text
CF = 0  A20 enabled and verified
CF = 1  A20 could not be enabled or verified
```

## ScrStage2IsA20Enabled

Description:

Tests whether A20 is enabled by checking whether two addresses separated by 1 MiB alias to the same physical memory.

Output:

```text
CF = 0  A20 enabled
CF = 1  A20 disabled
```

Temporary memory use:

```text
0000:0700
FFFF:0710
```

The original bytes are restored before the routine returns.
