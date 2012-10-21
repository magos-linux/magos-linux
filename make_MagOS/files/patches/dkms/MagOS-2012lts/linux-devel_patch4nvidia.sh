#!/bin/bash
CPATH=$PWD
cd usr/src/kernel-magos-devel-*
cp -p arch/x86/include/generated/asm/* arch/x86/include/asm
touch arch/x86/include/asm/system.h
cd $CPATH