# ScratchOS System Architecture

## Purpose

This document describes the current technical architecture of ScratchOS as it exists in the source code.

For high-level project goals and future subsystems, see `ARCHITECTURE.md`.

## Current Execution Flow

```text
Legacy BIOS
↓
Loads sector 1 at 0000:7C00
↓
ScratchBoot Stage1
↓
Reads sectors 2 and 3 through BIOS INT 13h
↓
Loads Stage2 at 0000:7E00
↓
Transfers execution to Stage2
↓
Stage2 initializes real-mode registers and stack
↓
Stage2 reads BIOS E820 memory map
↓
Stage2 verifies or enables A20
↓
System halts and waits for the next development stage
```

## Boot Image Layout

```text
Offset       Sector   Content
-----------------------------------------
0x000000     1        ScratchBoot Stage1
0x000200     2        ScratchBoot Stage2
0x000400     3        ScratchBoot Stage2 or padding
```

Current image size:

```text
1536 bytes
```

## Stage1 Architecture

Stage1 is loaded by Legacy BIOS at:

```text
0000:7C00
```

Stage1 is limited to one sector:

```text
512 bytes
```

Stage1 responsibilities:

1. Start at its explicit entry point.
2. Initialize the basic real-mode environment.
3. Store the BIOS boot-drive identifier for disk routines.
4. Print the boot banner.
5. Read two Stage2 sectors from disk.
6. Jump to Stage2 at `0000:7E00`.

Stage1 currently uses conventional CHS BIOS disk access:

```text
Cylinder: 0
Head:     0
Sector:   2
Count:    2 sectors
```

## Stage2 Architecture

Stage2 begins at:

```text
0000:7E00
```

Maximum supported size:

```text
1024 bytes
```

Stage2 initializes:

```text
DS = 0000
ES = 0000
SS = 0000
SP = 7A00
Direction Flag = clear
```

Stage2 currently performs these operations:

```text
1. Print startup message
2. Collect BIOS E820 memory-map entries
3. Count collected entries
4. Check whether A20 is active
5. Request BIOS A20 enable if required
6. Verify that A20 is active
7. Halt
```

## E820 Memory Map Collection

Stage2 invokes BIOS memory detection through:

```text
INT 15h
EAX = E820h
EDX = 534D4150h ("SMAP")
ECX = 20
```

Each stored E820 entry has this structure:

```text
Offset  Size  Field
-----------------------------
0       8     Base physical address
8       8     Region length
16      4     Region type
```

Stage2 stores up to 16 non-zero-length entries.

```text
Entry size:      20 bytes
Maximum entries: 16
Total buffer:    320 bytes
Buffer address:  0000:0500
```

The current QEMU test environment returns seven entries.

## A20 Verification

Stage2 tests whether addresses separated by 1 MiB alias to the same location.

Temporary test locations:

```text
Low-memory test location:   0000:0700
High-memory test location:  FFFF:0710
Physical high address:      00100700
```

The original bytes are restored after the test.

When A20 is disabled, Stage2 requests enablement through:

```text
INT 15h
AX = 2401h
```

Afterward, Stage2 repeats the memory-alias test.

## Current Architectural Invariants

The following rules must remain true unless the boot design is intentionally updated:

* Stage1 must remain exactly 512 bytes.
* Stage1 must end with the boot signature `AA55h`.
* Stage2 must not exceed 1024 bytes.
* Stage1 must load the same number of Stage2 sectors that the Makefile reserves in the image.
* The E820 buffer at `0000:0500` must not overlap other ScratchBoot memory.
* The Stage2 stack begins at `0000:7A00` and grows downward.
* Stage2 must initialize its own real-mode environment.
* ScratchBoot must verify A20 before Protected Mode or Long Mode work begins.
* The current boot path relies on Legacy BIOS, not UEFI.
* No filesystem is used by the current boot path.

## Current Limitations

* No GDT exists yet.
* No Protected Mode exists yet.
* No paging exists yet.
* No Long Mode exists yet.
* No kernel image is loaded.
* No structured Stage2-to-kernel boot information exists yet.
* No filesystem loader exists yet.
* No UEFI boot path exists yet.

## Next Architectural Change

The next planned change is the addition of a Global Descriptor Table.

That work must preserve the current successful path:

```text
BIOS
→ Stage1
→ Stage2
→ E820
→ A20
→ GDT preparation
```
