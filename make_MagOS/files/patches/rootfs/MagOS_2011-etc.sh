#!/bin/bash
echo SYSTEM=\"MagOS Linux\" > etc/sysconfig/oem
echo PRODUCT=2011 >> etc/sysconfig/oem
cat >etc/os-release <<EOF
NAME="MagOS Linux"
VERSION="2011"
ID=mandriva
VERSION_ID=2010.2
PRETTY_NAME="MagOS Linux"
ANSI_COLOR="1;34"
HOME_URL="http://www.magos-linux.ru/"
EOF
