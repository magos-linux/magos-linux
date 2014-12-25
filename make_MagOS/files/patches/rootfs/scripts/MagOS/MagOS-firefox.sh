#!/bin/bash
[ -e usr/bin/firefox -o -h usr/bin/firefox ] || exit 0
ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html usr/share/mdk/bookmarks/mozilla/mozilla-download.html
ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html usr/share/mdk/bookmarks/mozilla/mozilla-one.html
ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html usr/share/mdk/bookmarks/mozilla/mozilla-powerpack.html
PFP=$(ls -d1 usr/lib/firefox-* 2>/dev/null | tail -1 )
[ "$PFP" = "" ] && PFP=$(ls -d1 usr/lib64/firefox-* | tail -1 2>/dev/null)
[ -d "$PFP"/browser ] && [ ! -d "$PFP"/browser/defaults ] && ln -sf ../defaults "$PFP"/browser/defaults
[ -d "$PFP"/defaults/profile ] || exit 0
ln -sf /usr/share/magos/mozilla/firefox-prefs.js "$PFP"/defaults/profile/prefs.js
exit 0
