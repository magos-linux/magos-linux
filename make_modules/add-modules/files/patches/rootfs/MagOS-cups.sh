#!/bin/bash
PFP=etc/cups/cupsd.conf
grep -q "RIPCache 50m" $PFP || echo "RIPCache 50m" >> $PFP
exit 0
