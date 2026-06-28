# ScratchOS Architecture

## Philosophy

ScratchOS is a modern operating system written entirely from scratch.

Project goals:

* Usable
* Undemanding
* Fast

Everything is developed specifically for ScratchOS, including:

* Bootloader
* Kernel
* Drivers
* HAL
* Filesystem
* Desktop Environment
* Applications

No existing operating system components are intended to become permanent dependencies.

---

# Overall Architecture

```
BIOS
 │
 ▼
ScratchBoot Stage1 (16-bit)
 │
 ▼
ScratchBoot Stage2
 │
 ▼
Protected Mode (32-bit)
 │
 ▼
Long Mode (64-bit)
 │
 ▼
ScratchKernel
 │
 ├── HAL
 ├── Memory Manager
 ├── Scheduler
 ├── Virtual File System
 ├── Drivers
 ├── System Calls
 └── Userspace
```

---

# ScratchBoot

ScratchBoot is responsible for system startup.

## Stage1

Responsibilities:

* BIOS startup
* Display boot banner
* Initialize basic services
* Load Stage2
* Transfer execution

Maximum size:

512 bytes

---

## Stage2

Responsibilities:

* Memory detection
* Enable A20
* Build GDT
* Enter Protected Mode
* Enter Long Mode
* Load ScratchKernel

---

# ScratchKernel

ScratchKernel is the heart of ScratchOS.

Responsibilities:

* Memory Management
* Process Scheduling
* Hardware Abstraction Layer
* Drivers
* Virtual File System
* System Calls
* IPC
* Power Management

Architecture:

x86_64

Languages:

* C
* Assembly

---

# Hardware Abstraction

ScratchOS separates hardware access into layers.

```
Applications

↓

Libraries

↓

Kernel

↓

HAL

↓

Drivers

↓

Hardware
```

This architecture allows hardware-specific code to remain isolated.

---

# Boot Architecture

```
BIOS

↓

Stage1

↓

Stage2

↓

ScratchKernel

↓

Userspace
```

---

# Project Structure

```
ScratchOS/

boot/
    stage1/
    stage2/

kernel/

drivers/

hal/

fs/

lib/

docs/

tools/
```

---

# Development Principles

Every module should have one responsibility.

Examples:

bios.asm

* BIOS functions

disk.asm

* Disk abstraction

print.asm

* Text output

banner.asm

* Boot banner

Each module should remain independent whenever possible.

---

# Long-Term Vision

ScratchOS aims to become a complete operating system featuring:

* Native graphical desktop
* ScratchFS
* ScratchShell
* ScratchTerm
* Package manager
* Networking
* USB support
* Audio subsystem
* Modern driver model

Development starts from the boot sector and progresses toward a fully independent operating system.
