#!/bin/bash
PFP=etc/gnokiirc
grep -q '^port = /dev/modem' $PFP && exit 0
sed -i 's|^port = none|port = /dev/modem|' $PFP
sed -i '0,/^model = fake/s|^model = fake|model = AT|' $PFP
exit 0
