#!/bin/bash
[ -f etc/cups/cupsd.conf  ] || exit 0
grep -q "RIPCache 50m" etc/cups/cupsd.conf  && exit 0
echo "RIPCache 50m" >> etc/cups/cupsd.conf
exit 0
