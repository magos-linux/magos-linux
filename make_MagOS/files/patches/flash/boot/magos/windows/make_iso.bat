@ECHO OFF
set CDLABEL=MagOS
cd ..\..\..\
boot\grub4dos\xorriso.exe -as mkisofs -o "%CDLABEL%.iso" -v -J -R -D -A "%CDLABEL%" -V "%CDLABEL%" -graft-points -m '*_save*' boot=boot EFI=EFI MagOS=MagOS isomode=boot/grub4dos/iso_conf  --no-emul-boot -boot-info-table -boot-load-size 4 --boot-catalog-hide  -b boot/grub4dos/magos.ldr -iso_mbr_part_type 0x83 --mbr-force-bootable --partition_offset 16  -eltorito-alt-boot -isohybrid-mbr boot/syslinux/isohdpfx.bin -e EFI/efi.img
echo.
echo New ..\..\..\%CDLABEL%.iso should be created now.
pause
