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







Version: 0.1.5
Status: Development

# Changelog

## [Unreleased] — 2026-06-29

### Added

* Added automatic build support for both ScratchBoot stages:

  * `boot.bin` for Stage1
  * `stage2.bin` for Stage2
  * `scratchos.img` as the bootable raw disk image
* Added NASM include paths to the build process for:

  * `boot/stage1/`
  * `boot/stage2/`
* Added a two-sector boot image layout:

  * Sector 1: Stage1 boot sector
  * Sector 2: Stage2 loader
* Added Stage1 support for loading Stage2 from disk through BIOS `INT 13h`.
* Added a jump from Stage1 to Stage2 at address `0000:7E00`.
* Added an on-screen Stage1 disk-read error message.
* Added independent Stage2 initialization:

  * `DS`, `ES`, and `SS` set to `0`
  * Stage2 stack initialized at `0000:7A00`
  * Direction flag cleared with `CLD`
* Added BIOS E820 memory-map support in Stage2.
* Added storage for E820 memory-map entries in low memory at `0000:0500`.
* Added a limit of 16 E820 memory-map entries to prevent accidental memory overwrites.
* Added a build-time safety check that rejects Stage2 files larger than 512 bytes, because Stage1 currently loads one sector only.

### Changed

* Updated the build image process to pad `scratchos.img` to 1024 bytes.
* Updated the `clean` target so it removes build files while preserving the `build/` directory.
* Updated Stage1 so execution starts at the `start` label before included library code.
* Updated Stage1 to initialize the real-mode environment before calling BIOS helper routines.

### Verified

* BIOS E820 memory-map collection completed successfully in QEMU.
* BIOS returned and ScratchOS counted 7 E820 memory-map entries.
* `make` successfully builds Stage1, Stage2, and the disk image.
* `boot.bin` is exactly 512 bytes and contains a valid boot signature.
* `scratchos.img` is padded to two full 512-byte sectors.
* QEMU successfully boots ScratchOS.
* Stage1 displays its banner.
* Stage1 loads Stage2 from the second disk sector.
* Stage2 starts successfully and displays its startup message.
* BIOS E820 memory-map collection completes successfully in QEMU.

### Known Issue

* There is currently no Known Issue

### Next Step

* Verify and correct the decimal-number printing path used for `MemoryMapEntryCount`.
* Display the actual number of E820 memory-map entries returned by BIOS.

