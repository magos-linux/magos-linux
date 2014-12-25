#!/bin/bash
echo SYSTEM=\"MagOS Linux\" > etc/sysconfig/oem
echo PRODUCT=2012 >> etc/sysconfig/oem
cat >etc/os-release <<EOF
NAME="MagOS Linux"
VERSION="2012.XS"
ID=rosa
VERSION_ID=2012
PRETTY_NAME="MagOS Linux"
ANSI_COLOR="1;34"
HOME_URL="http://www.magos-linux.ru/"
EOF
