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
call :t_echo This installer will add Grub4dos loader to Windows 2k/XP loader.
call :t_echo On boot you will be promted which OS will be booted.
        echo.
if not exist c:\boot.ini goto NotXP
call :t_echo Press any key to continue or kill this window to abort...
pause > nul

cls
call :t_echo Changing attributes of c:\boot.ini ...
attrib -S -H -R c:\boot.ini
call :t_echo Adding grub4dos to c:\boot.ini ...
echo c:\magos.ldr=MagOS Linux >> c:\boot.ini
call :t_echo Copying grub4dos loader  to c:\ ...
copy /y %RUND%\boot\grub4dos\magos.ldr c:\magos.ldr
call :t_echo Changing back attributes of c:\boot.ini ...
attrib +S +H +R c:\boot.ini
call :t_echo Done. Check files and reboot. Press enter.
:pauseit
pause > nul

exit 0

:t_echo
set TMES=%*
if exist %TRANSLATE% for /f "eol=# tokens=1,2* delims=,@" %%i in (%TRANSLATE%) do if "%TMES%"=="%%i" set TMES=%%j
echo %TMES%
exit /b 0
:NotXP
call :t_echo Error: can't find c:\boot.ini. This script is only for Windows 2k/XP
goto pauseit
