@ECHO OFF
set CDLABEL=MagOS
cd ..\..\..\
boot\grub4dos\mkisofs.exe @boot\grub4dos\iso_conf -o "%CDLABEL%.iso" -A "%CDLABEL%" -V "%CDLABEL%" -m '*_save*' MagOS=MagOS boot=boot EFI=EFI magos.ldr=boot\grub4dos\magos.ldr isomode=boot\grub4dos\iso_conf
echo.
echo New ..\..\..\%CDLABEL%.iso should be created now.
pause
