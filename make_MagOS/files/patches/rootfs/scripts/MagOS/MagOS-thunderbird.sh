#!/bin/bash
[ -e usr/bin/thunderbird -o -h usr/bin/thunderbird ] || exit 0
PFP=$(ls -d1 usr/lib/thunderbird-* 2>/dev/null| tail -1)
[ "$PFP" = "" ] && PFP=$(ls -d1 usr/lib64/thunderbird-* | tail -1)
[ -d "$PFP"/defaults ] || exit 0
mkdir -p "$PFP"/defaults/profile
ln -sf /usr/share/magos/mozilla/thunderbird-prefs.js "$PFP"/defaults/profile/prefs.js
#Register ru locale when it is added manually
LIGHTNINGP='usr/lib/mozilla/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}/{e2fda1a4-762b-4020-b5ad-a41df1933103}'
[ -d $LIGHTNINGP ] || LIGHTNINGP='usr/lib64/mozilla/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}/{e2fda1a4-762b-4020-b5ad-a41df1933103}'
if [ -f $LIGHTNINGP/chrome/lightning-ru.jar ] ;then
  if ! grep -q lightning-ru $LIGHTNINGP/chrome.manifest ;then
cat >>$LIGHTNINGP/chrome.manifest <<EOF 
locale calendar ru jar:chrome/calendar-ru.jar!/locale/ru/calendar/
locale lightning ru jar:chrome/lightning-ru.jar!/locale/ru/lightning/
EOF
  fi
fi
exit 0