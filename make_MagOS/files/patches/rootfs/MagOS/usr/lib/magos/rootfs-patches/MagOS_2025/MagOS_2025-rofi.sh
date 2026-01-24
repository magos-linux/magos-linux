#!/bin/bash
[ -x /usr/bin/rofi ] || exit 0
PFP=/usr/share/magos/i3/rofi.cfg
grep -q configuration /usr/share/magos/i3/rofi.cf 2>/dev/null && exit 0
mkdir -p $(dirname $PFP)
cat >$PFP <<EOF
configuration {
combi-modi: "drun,run,ssh";
font: "hack 12";
modi: "combi";
}
@theme "/usr/share/rofi/themes/android_notification.rasi"
EOF
