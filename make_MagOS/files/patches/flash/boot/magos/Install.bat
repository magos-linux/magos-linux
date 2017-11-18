echo "Install script for MagOS Linux boot loader."
goto :win 
echo "Launching default Linux script ..."
cd $(dirname $0)/linux
EXECSH=/bin/bash
[ -x $EXECSH ] || EXECSH=/bin/sh
$EXECSH bootinst.sh
exit 0

:win
@echo off
echo "Detected Windows ..."
set RUND=%~d0
%RUND%
cd %RUND%\boot\magos\windows
echo %RUND%\boot\magos\windows
if exist %RUND%\ntldr goto :ntldr
if exist c:\ntldr goto :syslinux
if %RUND% == C: goto :bcd
if exist %RUND%\boot\bcd goto :bcd
if exist %RUND%\Windows\System32\bcdedit.exe goto :bcd
wmic logicaldisk where drivetype=3 get name | find "%RUND%" >nul
if %errorlevel% == 0 goto :bcd
:syslinux
echo "Installing syslinux to partition ..."
bootinst.bat
goto :endofwin
:bcd
echo "Detected Vista/7/8 boot manager, adding grub4dos ..."
add2bcd.bat
goto :endofwin
:ntldr
echo "Detected NTLDR, adding grub4dos ..."
add2ntld.bat
goto :endofwin
:endofwin
cd ../../
