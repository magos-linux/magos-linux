#!/bin/bash
[ -e /usr/bin/firefox -o -h /usr/bin/firefox ] || exit 0
PFP=$(ls -d1 /usr/lib/firefox-* 2>/dev/null | tail -1 )
[ "$PFP" = "" ] && PFP=$(ls -d1 /usr/lib64/firefox-* | tail -1 2>/dev/null)
#old versions <46
#[ -d "$PFP"/browser ] && [ ! -d "$PFP"/browser/defaults ] && ln -sf ../defaults "$PFP"/browser/defaults
if [ -d "$PFP"/defaults/profile ] ;then
   ln -sf /usr/share/magos/mozilla/firefox-prefs.js "$PFP"/defaults/profile/prefs.js
   ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html "$PFP"/defaults/profile/bookmarks.html
fi
#new versions
[ -f "$PFP/firefox.cfg.default" ] || mv -f "$PFP/firefox.cfg" "$PFP/firefox.cfg.default"
[ -h "$PFP/firefox.cfg" ] || ln -sf /usr/share/magos/mozilla/firefox.cfg "$PFP/firefox.cfg"
[ -h "$PFP/distribution" ] || ln -sf /usr/share/magos/mozilla/distribution "$PFP/distribution"
exit 0
