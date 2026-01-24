#!/bin/bash

[ -x /usr/bin/polybar ] || exit 0

sed -i s/'font-2 = siji:pixelsize=10;1'/'font-2 = Wuncon Siji:pixelsize=10;1'/ /usr/share/magos/i3/polybar.cfg

exit 0
