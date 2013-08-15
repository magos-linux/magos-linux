#!/bin/bash
CPATH=$PWD
cd /usr/src/linux-$KERN || exit 1
mkdir -p arch/x86/include/asm
cp -p arch/x86/include/generated/asm/* arch/x86/include/asm
touch arch/x86/include/asm/system.h
cd $CPATH