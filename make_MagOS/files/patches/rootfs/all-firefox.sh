#!/bin/bash

[ -d usr/lib/firefox-*/defaults/profile ] || exit 0
ln -sf /usr/share/magos/firefox-prefs.js usr/lib/firefox-*/defaults/profile/prefs.js

exit 0