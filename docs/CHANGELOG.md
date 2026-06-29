# ScratchOS Changelog

All notable changes to ScratchOS will be documented in this file.

The project follows a milestone-based development model.

---

# Version 0.1.0 - "ScratchBoot Foundation"

Release Date: 2026

## Added

### Project

* Initial ScratchOS project structure.
* Build system using Makefile.
* Documentation directory.
* System architecture planning.

### ScratchBoot Stage1

* Custom 512-byte boot sector.
* BIOS-compatible bootloader.
* Boot signature (0xAA55).
* Boot banner.

### ScratchBoot Libraries

* BIOS Library (`bios.asm`)
* Print Library (`print.asm`)
* Banner Library (`banner.asm`)
* Disk Library skeleton (`disk.asm`)

### BIOS API

Implemented:

* ScrBiosPrintChar()

Planned:

* ScrBiosReadSector()
* ScrBiosResetDisk()

### ScratchDisk API

Skeleton created:

* ScrDiskInit()
* ScrDiskReadSector()
* ScrDiskReset()

### Stage2

* Stage2 directory.
* Stage2 skeleton.
* Stage2 documentation.

### Documentation

Added:

* README.md
* ROADMAP.md
* ARCHITECTURE.md
* SYSTEM_ARCHITECTURE.md
* BIOS.md

---

## Current Status

Completed:

✔ ScratchBoot Stage1

✔ Modular architecture

✔ BIOS text output

✔ Stage2 skeleton

✔ Project documentation

In Progress:

* Disk I/O

Planned:

* Stage2 Loader
* Memory Detection
* A20 Line
* GDT
* Protected Mode
* ScratchKernel (x86_64)

---

Version: 0.1.0
Status: Development
