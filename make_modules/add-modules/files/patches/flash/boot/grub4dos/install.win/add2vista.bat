@echo off
set TRANSLATE=ru.nls
set RUND=%0
set RUND=%RUND:"=%
set RUND=%RUND:\boot\grub4dos\install.win\add2vista.bat=%
if not exist C:\Windows\System32\bcdedit.exe goto setp2me
if not exist %RUND%\boot\tools\win\sed.exe goto setp2me
Set BCDEDIT=C:\Windows\System32\bcdedit.exe
Set SED=%RUND%\boot\tools\win\sed.exe

        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
call :t_echo Welcome to MagOS boot installer
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        echo.
call :t_echo This installer will add Grub4dos loader to Windows Vista/7 loader.
call :t_echo On boot you will be promted which OS will be booted.
        echo.
call :t_echo Press any key to continue or kill this window to abort...
pause > nul

cls

call :t_echo Copying grub4dos files to boot drive ...
copy /y %RUND%\boot\grub4dos\magos.ldr %RUND%\magos.ldr

call :t_echo Setting bootloader ...
%BCDEDIT% /create /d "MagOS Linux" /application bootsector |  %SED% s/^.*{/{/ | %SED% s/}.*$/}/ >%TEMP%\grub4dos.id
for /f %%A in (%TEMP%\grub4dos.id) do set guid=%%A
echo GUID = %guid%

%BCDEDIT% /set %guid% device partition=%RUND%
%BCDEDIT% /set %guid% path \boot\grub4dos\magos.mbr
%BCDEDIT% /displayorder %guid% /addlast

call :t_echo Done. Check files and reboot. Press enter.
goto endofall

:setp2me
call :t_echo Error: Binaries are not found. Correct path in script please. 
goto endofall

:endofall
pause

exit 0

:t_echo
set TMES=%*
if exist %TRANSLATE% for /f "eol=# tokens=1,2* delims=,@" %%i in (%TRANSLATE%) do if "%TMES%"=="%%i" set TMES=%%j
echo %TMES%

exit /b 0
