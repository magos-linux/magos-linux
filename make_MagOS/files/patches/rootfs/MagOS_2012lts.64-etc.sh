#!/bin/bash
echo SYSTEM=\"MagOS Linux\" > etc/sysconfig/oem
echo PRODUCT=2012lts >> etc/sysconfig/oem
cat >etc/os-release <<EOF
NAME="MagOS Linux"
VERSION="2012lts"
ID=mandriva
VERSION_ID=2012lts
PRETTY_NAME="MagOS Linux"
ANSI_COLOR="1;34"
HOME_URL="http://www.magos-linux.ru/"
EOF
