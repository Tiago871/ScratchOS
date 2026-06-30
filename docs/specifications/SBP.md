# Scratch Boot Protocol

## Status

Draft

## Version

0.1

## Scope

Scratch Boot Protocol, abbreviated as SBP, defines the startup contract used by ScratchBoot.

This version describes the current Legacy BIOS boot path and reserves space for the future transition to ScratchKernel.

UEFI support is not part of the current protocol implementation.

## Current Boot Flow

```text
Legacy BIOS
↓
ScratchBoot Stage1
↓
ScratchBoot Stage2
↓
Future: Protected Mode
↓
Future: Long Mode
↓
Future: ScratchKernel
```

## Current Stage1 Contract

Legacy BIOS loads Stage1 from the first disk sector.

```text
Load address: 0000:7C00
Maximum size: 512 bytes
```

Stage1 responsibilities:

* Initialize the basic real-mode environment.
* Save the BIOS boot-drive identifier for Stage1 disk routines.
* Display the ScratchOS boot banner.
* Load Stage2 from sectors 2 and 3.
* Transfer execution to Stage2.

## Current Stage2 Contract

Stage1 loads Stage2 at:

```text
0000:7E00
```

Stage2 currently performs:

* Real-mode segment and stack initialization
* BIOS E820 memory-map collection
* E820 entry counting
* A20 verification
* BIOS A20 enable request when required
* Diagnostic text output

Stage2 currently stops after completing these preparation steps.

## Current Disk Contract

```text
Sector 1: ScratchBoot Stage1
Sector 2: ScratchBoot Stage2
Sector 3: ScratchBoot Stage2 or padding
```

Stage1 loads two sectors beginning at sector 2.

## Current Memory Contract

```text
Stage1 load address:        0000:7C00
Stage2 load address:        0000:7E00
Stage2 stack start:         0000:7A00
E820 buffer:                0000:0500
Maximum E820 entries:       16
```

## Current BIOS Requirements

The current SBP implementation requires a Legacy BIOS environment that supports:

```text
INT 10h text output
INT 13h disk read
INT 15h E820 memory map
INT 15h A20 enable request
```

## Future ScratchKernel Contract

Before ScratchKernel is introduced, SBP will define a structured boot-information block.

The future block is expected to include:

* Boot-drive information
* E820 memory-map address
* E820 memory-map entry count
* CPU mode information
* Framebuffer information when available
* Kernel load address
* Command-line or boot configuration data

No final binary layout has been defined yet.

## Protocol Rules

* Stage1 must remain a valid 512-byte BIOS boot sector.
* Stage2 must initialize its own real-mode environment.
* Stage2 must not exceed the number of sectors loaded by Stage1.
* Stage2 must collect memory information before kernel memory management begins.
* A20 must be verified before entering Protected Mode or Long Mode.
* The current protocol must not claim UEFI support until a separate UEFI loader exists.

## Planned Protocol Evolution

```text
SBP 0.1
Legacy BIOS Stage1 → Stage2

SBP 0.2
GDT and 32-bit Protected Mode preparation

SBP 0.3
Paging and 64-bit Long Mode

SBP 1.0
Structured handoff from ScratchBoot to ScratchKernel
```
