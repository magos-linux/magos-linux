@ECHO OFF
set CDLABEL=MagOSboot
cd ..\..\..\
boot\grub4dos\mkisofs.exe @boot\grub4dos\iso_conf -o "%CDLABEL%.iso" -A "%CDLABEL%" -V "%CDLABEL%" MagOS/vmlinuz=MagOS\vmlinuz MagOS/initrd.gz=MagOS\initrd.gz boot=boot EFI=EFI magos.ldr=boot\grub4dos\magos.ldr
echo.
echo New ..\..\..\%CDLABEL%.iso should be created now.
pause
