#!/bin/bash
CPATH=$PWD
cd usr/src/kernel-magos-devel-* 2>/dev/null || cd usr/src/linux-*
mkdir -p arch/x86/include/asm
cp -p arch/x86/include/generated/asm/* arch/x86/include/asm
touch arch/x86/include/asm/system.h
cd $CPATH