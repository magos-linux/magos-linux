@echo off
cls
set TRANSLATE=ru.nls
set DISK=none
set BOOTFLAG=boot666s.tmp

echo This file is used to determine current drive letter. It should be deleted. >\%BOOTFLAG%
if not exist \%BOOTFLAG% goto readOnly

call :t_echo Searching for current drive letter.
for %%d in ( C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if exist %%d:\%BOOTFLAG% set DISK=%%d
cls
del \%BOOTFLAG%
if %DISK% == none goto DiskNotFound

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
call :t_echo Setting bootloader ...

if %OS% == Windows_NT goto setupNT
goto setup95

:setupNT
\boot\syslinux\syslinux.exe -maf -d \boot\syslinux %DISK%:
goto setupDone

:setup95
\boot\syslinux\syslinux.com -maf -d \boot\syslinux %DISK%:

:setupDone
call :t_echo Disk should be bootable now. Installation finished.
goto pauseit

:readOnly
call :t_echo You're starting MagOS installer from a read-only media. This will not work.
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
