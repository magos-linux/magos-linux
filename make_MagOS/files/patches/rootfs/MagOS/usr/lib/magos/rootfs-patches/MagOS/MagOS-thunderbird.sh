#!/bin/bash
[ -e /usr/bin/thunderbird -o -h /usr/bin/thunderbird ] || exit 0
PFP=$(ls -d1 /usr/lib/thunderbird* 2>/dev/null| tail -1)
[ "$PFP" = "" ] && PFP=$(ls -d1 /usr/lib64/thunderbird* | tail -1)
[ -d "$PFP"/defaults ] || exit 0
mkdir -p "$PFP"/defaults/profile
ln -sf /usr/share/magos/mozilla/thunderbird-prefs.js "$PFP"/defaults/profile/prefs.js
exit 0
