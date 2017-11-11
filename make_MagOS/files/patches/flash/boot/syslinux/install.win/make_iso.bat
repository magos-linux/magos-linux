@ECHO OFF

REM  ----------------------------------------------------
REM  Batch file to create bootable ISO in Windows
REM  author: Tomas M. <http://www.linux-live.org>
REM  ----------------------------------------------------

cd ..\..\..\
set CDLABEL=MagOS
set ISOPATH=..
if exist "..\MagOS" set ISOPATH=c:
boot\tools\WIN\mkisofs.exe @boot\syslinux\iso_conf -o "%ISOPATH%\%CDLABEL%.iso" -A "%CDLABEL%" -V "%CDLABEL%" -m '*_save*' MagOS=MagOS boot=boot isolinux.cfg=boot/syslinux/syslinux.cfg isomode=boot/syslinux/iso_conf
echo.
echo New ISO should be created now. See %ISOPATH%\%CDLABEL%.iso

pause
