#!/bin/bash
ln -sf magos-bookmarks.html usr/share/mdk/bookmarks/mozilla/mozilla-download.html
ln -sf magos-bookmarks.html usr/share/mdk/bookmarks/mozilla/mozilla-one.html
ln -sf magos-bookmarks.html usr/share/mdk/bookmarks/mozilla/mozilla-powerpack.html
PFP=$(ls -d1 usr/lib/firefox-* | tail -1)
[ -d "$PFP"/browser ] && [ ! -d "$PFP"/browser/defaults ] && ln -sf ../defaults "$PFP"/browser/defaults
[ -d "$PFP"/defaults/profile ] || exit 0
ln -sf /usr/share/magos/mozilla/firefox-prefs.js "$PFP"/defaults/profile/prefs.js
exit 0
