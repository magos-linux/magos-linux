@ECHO OFF
REM #########################################################################
REM DOS batch file to boot Linux.

REM First, ensure any unwritten disk buffers are flushed:
@smartdrv /C

REM Start the LINLD process:
cls
linld097.com image=..\..\..\MagOS\vmlinuz initrd=..\..\..\MagOS\initrd.gz cl=@config %1 %2 %3

REM #########################################################################
