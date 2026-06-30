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

Version: 0.2.0
Status: Development

# Changelog

All notable changes to ScratchOS are documented in this file.

## [Unreleased]

### Added

* Added a two-stage ScratchBoot boot path.
* Added Stage1 loading of Stage2 through BIOS INT 13h.
* Added Stage1 transfer of execution to Stage2 at `0000:7E00`.
* Added a Stage1 disk-read error path and on-screen error message.
* Added independent Stage2 real-mode initialization:

  * `DS`, `ES`, and `SS` initialized to `0`
  * Stage2 stack initialized at `0000:7A00`
  * Direction Flag cleared with `CLD`
* Added BIOS E820 memory-map collection in Stage2.
* Added storage for up to 16 E820 memory-map entries at `0000:0500`.
* Added decimal output for the E820 entry count.
* Added A20 detection and verification.
* Added a BIOS A20 enable request through INT 15h / AX=2401h when A20 is disabled.
* Added a build-time Stage2 size check in the Makefile.

### Changed

* Stage1 now loads two Stage2 sectors instead of one.
* Stage2 maximum supported size increased from `512 B` to `1024 B`.
* The raw ScratchOS disk image now has a size of `1536 B`.
* The boot image layout now contains:

  * Sector 1: Stage1
  * Sector 2: Stage2
  * Sector 3: Stage2 continuation or padding
* Added NASM include paths for Stage1 and Stage2 builds.
* Updated `make clean` to remove generated files while preserving the `build/` directory.

### Verified

* `boot.bin` builds as a valid 512-byte boot sector.
* Stage1 displays the ScratchOS boot banner.
* Stage1 loads Stage2 successfully from disk.
* Stage2 starts successfully at `0000:7E00`.
* Stage2 initializes its own real-mode environment.
* BIOS E820 memory-map collection completes successfully in QEMU.
* ScratchOS reports seven E820 entries in the current QEMU configuration.
* A20 is enabled and verified successfully in QEMU.
* Stage2 currently builds to `462 B`, within the `1024 B` loading limit.

### Current Limitations

* ScratchOS supports Legacy BIOS boot only.
* UEFI boot is not implemented.
* GDT is not implemented.
* 32-bit Protected Mode is not implemented.
* Paging is not implemented.
* 64-bit Long Mode is not implemented.
* ScratchKernel is not implemented.
* No filesystem is used during boot.
* Stage2 is loaded from fixed disk sectors.
* Stage1 loads only two Stage2 sectors.
