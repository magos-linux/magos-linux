#!/bin/bash
PFP=etc/X11/gdm/custom.conf
grep -q MagOS $PFP && exit 0
cat > $PFP <<EOF
#MagOS config for autologin
[daemon]
AutomaticLogin=user
AutomaticLoginEnable=true
EOF
exit 0
