echo "Start"
goto :win \
2>/dev/null
echo "Linux"
cd grub4dos/install.lin/
./bootinst_mbr.sh
exit 0
:win
echo "Windows"
cd grub4dos/install.win/
bootinst.bat