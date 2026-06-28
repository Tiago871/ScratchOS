# Scratch Boot Protocol (SBP)

## Status

Draft

## Version

0.1

## Description

Scratch Boot Protocol (SBP) is the official boot protocol used by ScratchOS.

It defines how ScratchBoot transfers control to ScratchKernel and what information is passed during system startup.

## Responsibilities

ScratchBoot is responsible for:

- Initializing the CPU
- Preparing memory
- Loading ScratchKernel
- Passing boot information
- Entering 64-bit mode

## Boot Flow

BIOS/UEFI

↓

ScratchBoot Stage1

↓

ScratchBoot Stage2

↓

ScratchKernel
