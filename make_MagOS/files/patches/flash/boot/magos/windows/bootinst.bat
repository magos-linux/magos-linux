@echo off
set TRANSLATE=ru.nls
set DISK=%~d0
%DISK% 
cd %DISK%\boot\magos\windows

cls
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
call :t_echo Welcome to MagOS boot installer
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        echo Install on disk %DISK% !
call :t_echo This installer will setup disk to boot only MagOS. Folders boot and MagOS
call :t_echo you must copy to destination drive manually. Run script only from dest. drive!
call :t_echo Warning! Master Boot Record (MBR) of the device will be overwritten.
call :t_echo If it is a partition on the same disk drive like your Windows installation
call :t_echo then your Windows will not boot anymore. Be careful!
        echo.
if %DISK% == C: goto DiskC
if exist c:\ntldr goto wait
net session >nul 2>&1
if %errorlevel% NEQ 0 goto NotAdmin

:wait
call :t_echo Press any key to continue or kill this window to abort...
pause > nul

cls
call :t_echo Setting bootloader ...
%DISK%\boot\syslinux\syslinux.exe -mafi %DISK%
if %errorlevel% NEQ 0 goto pauseit
call :t_echo Disk should be bootable now. Installation finished.

:pauseit
echo.
call :t_echo Read the information above and then press any key to exit...
pause > nul
exit 0

:t_echo
set TMES=%*
if exist %TRANSLATE% for /f "eol=# tokens=1,2* delims=,@" %%i in (%TRANSLATE%) do if "%TMES%"=="%%i" set TMES=%%j
echo %TMES%
exit /b 0

:DiskC
call :t_echo Error: can't install to disk C:. Run script from removable device to install.
goto pauseit

:NotAdmin
call :t_echo Error: can't write to device. Run script as administrator.
goto pauseit
