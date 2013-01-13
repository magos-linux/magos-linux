#!/bin/bash
echo SYSTEM=\"MagOS Linux\" > etc/sysconfig/oem
echo PRODUCT=2012RE >> etc/sysconfig/oem
cat >etc/os-release <<EOF
NAME="MagOS Linux"
VERSION="2012RE"
ID=rosa
VERSION_ID=2012RE
PRETTY_NAME="MagOS Linux"
ANSI_COLOR="1;34"
HOME_URL="http://www.magos-linux.ru/"
EOF
