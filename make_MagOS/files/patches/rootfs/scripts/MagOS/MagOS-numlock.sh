#!/bin/bash
rm -f etc/profile.d/numlock.sh 2>/dev/null
PFP=etc/X11/xinit.d/numlock
grep -q MagOS $PFP && exit 0
sed -i 's|DISPHOST=|\[ -f /etc/sysconfig/MagOS \] \&\& \. /etc/sysconfig/MagOS\nDISPHOST=|' $PFP
sed -i 's|if \[ -f /var/lock/subsys/numlock|/usr/bin/enable_X11_numlock off\n  if \[ -f /var/lock/subsys/numlock|' $PFP
sed -i 's|/usr/bin/enable_X11_numlock \]|/usr/bin/enable_X11_numlock -a "$NUMLOCK" != "no" \]|' $PFP
exit 0
