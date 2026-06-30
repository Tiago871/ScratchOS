# ScratchOS Architecture

## Project Philosophy

ScratchOS is designed around three long-term goals:

* Usable
* Undemanding
* Fast

The project aims to build an independent operating system from the bootloader upward. Permanent dependencies on another operating system are not part of the final design.

## Target Architecture

```text
x86_64
```

ScratchOS will ultimately run a 64-bit kernel.

The processor startup path remains compatible with standard x86 behavior:

```text
16-bit Real Mode
→ 32-bit Protected Mode
→ 64-bit Long Mode
→ ScratchKernel
```

A 64-bit processor can execute these earlier x86 modes during startup. Entering 32-bit Protected Mode is therefore a normal preparation step before entering 64-bit Long Mode.

## High-Level System Design

```text
Firmware
│
├── Legacy BIOS
│   └── Current implementation
│
└── UEFI
    └── Future implementation

Legacy BIOS
↓
ScratchBoot Stage1
↓
ScratchBoot Stage2
↓
32-bit Protected Mode
↓
64-bit Long Mode
↓
ScratchKernel
↓
Hardware Abstraction Layer
↓
Drivers
↓
Core Kernel Services
↓
Userspace
```

## ScratchBoot

ScratchBoot is responsible for starting the system and preparing the processor for the kernel.

### Stage1

Stage1 is the BIOS boot sector.

Responsibilities:

* Start execution from the first disk sector
* Preserve the BIOS boot-drive identifier for disk operations
* Initialize the basic real-mode environment
* Display the ScratchOS boot banner
* Load Stage2 from disk
* Transfer execution to Stage2

Constraints:

```text
Maximum size: 512 bytes
Load address: 0000:7C00
```

### Stage2

Stage2 is the expandable real-mode loader.

Current responsibilities:

* Initialize its own real-mode environment
* Prepare its own stack
* Collect the BIOS E820 memory map
* Verify or enable A20
* Display diagnostic status messages

Planned responsibilities:

* Build and load the GDT
* Enter 32-bit Protected Mode
* Build page tables
* Enter 64-bit Long Mode
* Load ScratchKernel
* Pass structured boot information to ScratchKernel

Current constraints:

```text
Load address: 0000:7E00
Maximum size: 1024 bytes
Loaded disk sectors: 2 and 3
```

## ScratchKernel

ScratchKernel will be the core of ScratchOS.

Planned responsibilities:

* Physical memory management
* Virtual memory management
* Process scheduling
* Interrupt handling
* System calls
* IPC
* Hardware abstraction
* Driver management
* Virtual filesystem layer
* Security and permissions
* Power management

Initial implementation languages:

```text
C
Assembly
```

## Hardware Abstraction

ScratchOS will keep hardware-specific logic isolated below the kernel core.

```text
Applications
↓
Userspace Libraries
↓
System Calls
↓
ScratchKernel
↓
HAL
↓
Drivers
↓
Hardware
```

## Filesystem Direction

ScratchOS does not currently use a filesystem during boot. Stage2 is loaded from fixed disk sectors.

Planned progression:

```text
Fixed-sector Stage2 loading
↓
FAT32 for initial kernel loading
↓
Virtual filesystem layer
↓
ScratchFS as a native ScratchOS filesystem
```

FAT32 is intended only as an early bootstrap filesystem because it is simple enough for an initial bootloader implementation. ScratchFS remains a long-term native filesystem goal.

## Firmware Support

Current status:

```text
Legacy BIOS: implemented
UEFI: planned
```

The current bootsector is intended for BIOS-compatible firmware and QEMU. A separate UEFI loader will be required for machines that support UEFI only.

## Development Principles

* One module should have one responsibility.
* Build and test after every small change.
* Preserve working checkpoints.
* Do not silently exceed boot-time memory or size limits.
* Document the current state separately from future plans.
* Avoid unnecessary refactoring of working low-level code.

## Current Development Roadmap

```text
Completed:
- Stage1 boot sector
- Stage1 → Stage2 transition
- E820 memory map
- A20 verification
- Two-sector Stage2 loading

Next:
- GDT
- 32-bit Protected Mode
- Paging preparation
- 64-bit Long Mode
- First ScratchKernel entry
```
