# ScratchBoot Stage2

## Purpose

Stage2 is responsible for preparing the system before the kernel starts.

Responsibilities:

- Memory detection
- Enable A20 line
- Create GDT
- Switch to Protected Mode
- Load ScratchKernel

Stage1 should remain as small as possible.
