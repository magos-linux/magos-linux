@echo off
set TRANSLATE=ru.nls
cls
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
call :t_echo Welcome to MagOS boot installer
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        echo.
call :t_echo This installer will add Grub4dos loader to Windows 2k/XP loader.
call :t_echo On boot you will be promted which OS will be booted.
        echo.
call :t_echo Press any key to continue or kill this window to abort...
pause > nul

cls
call :t_echo Changing attributes of c:\boot.ini ...
attrib -S -H  c:\boot.ini
call :t_echo Adding grub4dos to c:\boot.ini ...
        echo c:\magos.ldr=MagOS Linux >> c:\boot.ini
call :t_echo Copying grub4dos loader  to c:\ ...
copy /y ..\magos.ldr c:\magos.ldr
call :t_echo Changing back attributes of c:\boot.ini ...
attrib +S +H  c:\boot.ini
call :t_echo Done. Check files and reboot. Press enter.
pause > nul

exit 0

:t_echo
set TMES=%*
if exist %TRANSLATE% for /f "eol=# tokens=1,2* delims=,@" %%i in (%TRANSLATE%) do if "%TMES%"=="%%i" set TMES=%%j
echo %TMES%
exit /b 0
