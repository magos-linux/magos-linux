@echo off
cls
set TRANSLATE=ru.nls
set DISK=none
set BOOTFLAG=boot666s.tmp

call :t_echo This file is used to determine current drive letter. It should be deleted. >\%BOOTFLAG%
if not exist \%BOOTFLAG% goto readOnly

call :t_echo Searching for current drive letter.
for %%d in ( C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if exist %%d:\%BOOTFLAG% set DISK=%%d

if %DISK% == none goto DiskNotFound

set PATH=%PATH%;%DISKNUM%\boot\tools\win

if NOT %OS% == Windows_NT goto welcome

   mbrwiz /list | tr -d [:cntrl:]- -s " " | sed s/"Disk: "/\n/g >\%BOOTFLAG%

   set DISKNUM=none
   call :t_echo Searching for current drive number.
   for %%d in ( 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) do (
      grep -q -i "^%%d.* %DISK%: " \%BOOTFLAG% && set DISKNUM=%%d
      )

   if %DISKNUM% == none goto DiskNotFound
   echo Found in %DISKNUM% drive

   mbrwiz /list >\%BOOTFLAG%

   set DISKPART=none
   call :t_echo Searching for partition number.
   for %%d in ( 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) do (
      grep -q -i "^ *%%d .* %DISK%: " \%BOOTFLAG% && set DISKPART=%%d
      )

   if %DISKPART% == none goto DiskNotFound
   echo Found in %DISKPART% partition

:welcome

del \%BOOTFLAG%

cls

        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
call :t_echo Welcome to MagOS boot installer
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        echo Install on disk %DISK%: !
call :t_echo This installer will setup disk to boot only MagOS. Folders boot and Magos
call :t_echo you must copy to destination drive manually. Run script only from dest. drive!
call :t_echo Warning! Master Boot Record (MBR) of the device will be overwritten.
call :t_echo If it is a partition on the same disk drive like your Windows installation
call :t_echo then your Windows will not boot anymore. Be careful!
        echo.
call :t_echo Press any key to continue or kill this window to abort...
pause > nul

cls
call :t_echo Copying grub4dos files to boot drive ...
copy /y ..\magos.ldr ..\..\..\magos.ldr

if %OS% == Windows_NT goto setupNT
goto setup95

:setupNT
rem mbrwiz /list | grep -v -i mbrwiz | grep -v http | grep -v "^ Pos MBRndx" | grep -v  \-\-\-
mbrfix /drive %DISKNUM% listpartitions | grep -v -i mbrwiz | grep -v http | grep -v "^ Pos MBRndx" | grep -v  \-\-\- || goto error
echo %DISK%: founded on %DISKNUM% drive and %DISKPART%+1 partition
call :t_echo Please check information to specify your disk. 
call :t_echo IF NOT KILL THIS WINDOW [X] !!!
pause 

call :t_echo Setting bootloader ...
rem mbrfix /drive %DISKNUM% fixmbr /yes || goto error
mbrfix /drive %DISKNUM% restorembr ..\mbr.bin /yes || goto error
grubinst  --boot-file=magos.ldr --floppy=%DISKPART% (hd%DISKNUM%) || goto error
mbrwiz /disk=%DISKNUM% /part=%DISKPART% /active=1 /confirm 
goto setupDone

:setup95
call :t_echo Setting bootloader ...
bootlace.com --no-backup-mbr --time-out=0 %DISK%:

:setupDone
call :t_echo Disk should be bootable now. Installation finished.
goto pauseit

:readOnly
call :t_echo You're starting MagOS installer from a read-only media. This will not work.
goto pauseit

:error
call :t_echo Something went wrong. Aborting ...
goto pauseit

:DiskNotFound
call :t_echo Error: can't find out current drive letter

:pauseit
echo.
call :t_echo Read the information above and then press any key to exit...
pause > nul

:end
exit 0

:t_echo
set TMES=%*
if exist %TRANSLATE% for /f "eol=# tokens=1,2* delims=,@" %%i in (%TRANSLATE%) do if "%TMES%"=="%%i" set TMES=%%j
echo %TMES%
exit /b 0
