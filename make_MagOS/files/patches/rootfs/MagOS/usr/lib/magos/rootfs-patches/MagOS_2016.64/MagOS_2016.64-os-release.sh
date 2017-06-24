#!/bin/bash
FILE=/etc/os-release
cat >$FILE <<EOF
NAME="MagOS Linux 2016"
VERSION="2016"
ID=rosa
VERSION_ID=2016
PRETTY_NAME="MagOS Linux"
ANSI_COLOR="1;34"
HOME_URL="http://www.magos-linux.ru/"
BUG_REPORT_URL="http://www.magos-linux.ru/"
EOF

FILE=/etc/oem
cat >$FILE <<EOF
SYSTEM="MagOS Linux"
PRODUCT=2016
EOF

exit 0
