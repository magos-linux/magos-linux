@echo off
set TRANSLATE=ru.nls
set RUND=%~d0
%RUND% 
cd %RUND%\boot\magos\windows
cls
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
call :t_echo Welcome to MagOS boot installer
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        echo.
call :t_echo This installer will add Grub4dos loader to Windows Vista/7/8/10 loader.
call :t_echo On boot you will be promted which OS will be booted.
        echo.
if not exist C:\Windows\System32\bcdedit.exe goto setp2me
if not exist %RUND%\boot\grub4dos\magos.ldr goto setp2me
Set BCDEDIT=C:\Windows\System32\bcdedit.exe
net session >nul 2>&1
if %errorlevel% NEQ 0 goto NotAdmin

call :t_echo Press any key to continue or kill this window to abort...
pause > nul

cls

call :t_echo Copying grub4dos files to boot drive ...
copy /y %RUND%\boot\grub4dos\magos.ldr %RUND%\magos.ldr

call :t_echo Setting bootloader ...
%BCDEDIT% /create /d "MagOS Linux" /application bootsector >%TEMP%\grub4dos.id
for /F "delims={} tokens=2" %%i in (%TEMP%\grub4dos.id) do set guid=%%i
echo GUID = {%guid%}
%BCDEDIT% /set {%guid%} device partition=%RUND%
%BCDEDIT% /set {%guid%} path \boot\grub4dos\magos.mbr
%BCDEDIT% /displayorder {%guid%} /addlast

call :t_echo Done. Check files and reboot. Press enter.

:endofall
pause
exit 0

:t_echo
set TMES=%*
if exist %TRANSLATE% for /f "eol=# tokens=1,2* delims=,@" %%i in (%TRANSLATE%) do if "%TMES%"=="%%i" set TMES=%%j
echo %TMES%
exit /b 0

:setp2me
call :t_echo Error: Binaries are not found. Place boot folder in root of drive and run script from this drive.
goto endofall

:NotAdmin
call :t_echo Error: Run script as administrator.
goto endofall
