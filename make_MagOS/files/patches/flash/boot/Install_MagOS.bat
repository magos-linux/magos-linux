echo "Install script for MagOS Linux boot loader."
goto :win 
echo "Launching default Linux script ..."
[ -d grub4dos ] || cd $(dirname $0)
cd grub4dos/install.lin/
EXECSH=/bin/bash
[ -x $EXECSH ] || EXECSH=/bin/sh
$EXECSH bootinst_mbr.sh
exit 0

:win
@echo off
echo "Detected Windows ..."
if not exist grub4dos cd \boot
cd grub4dos\install.win\
if exist \ntldr goto :ntldr
if not exist \boot\bcd goto :flash
if not exist C:\Windows\System32\bcdedit.exe goto :flash
echo "Detected Vista/7 boot manager, adding grub4dos ..."
add2vista.bat
goto :endofwin
:flash
echo "Installing grub4dos to partition ..."
bootinst.bat
goto :endofwin
:ntldr
echo "Detected NTLDR, adding grub4dos ..."
add2ntld.bat
goto :endofwin
:endofwin
cd ../../
