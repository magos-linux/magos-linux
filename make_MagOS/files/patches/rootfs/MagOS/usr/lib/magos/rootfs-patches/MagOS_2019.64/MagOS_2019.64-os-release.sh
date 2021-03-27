#!/bin/bash
FILE=/etc/os-release
cat >$FILE <<EOF
NAME="MagOS Linux 2019"
VERSION="2019"
ID=rosa
VERSION_ID=2019
PRETTY_NAME="MagOS Linux"
ANSI_COLOR="1;34"
HOME_URL="http://www.magos-linux.ru/"
BUG_REPORT_URL="http://www.magos-linux.ru/"
EOF

FILE=/etc/oem
cat >$FILE <<EOF
SYSTEM="MagOS Linux"
PRODUCT=2019
EOF

exit 0
