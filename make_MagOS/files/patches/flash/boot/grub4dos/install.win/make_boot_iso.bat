@ECHO OFF

REM  ----------------------------------------------------
REM  Batch file to create bootable ISO in Windows
REM  author: Tomas M. <http://www.linux-live.org>
REM  ----------------------------------------------------

cd ..\..\..\
set CDLABEL=MagOSboot
set ISOPATH=..
if exist "..\MagOS" set ISOPATH=c:
boot\tools\WIN\mkisofs.exe @boot\grub4dos\iso_conf -o "%ISOPATH%\%CDLABEL%.iso" -A "%CDLABEL%" -V "%CDLABEL%" MagOS/vmlinuz=MagOS\vmlinuz MagOS/initrd.gz=MagOS\initrd.gz boot=boot EFI=EFI magos.ldr=boot\grub4dos\magos.ldr
echo.
echo New ISO should be created now. See %ISOPATH%\%CDLABEL%.iso

pause
