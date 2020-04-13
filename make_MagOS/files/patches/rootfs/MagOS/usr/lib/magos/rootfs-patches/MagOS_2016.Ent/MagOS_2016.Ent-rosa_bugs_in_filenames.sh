#!/bin/sh
rm -f /usr/lib64/aspell-0.60/bokmål.alias /usr/lib64/aspell-0.60/íslenska.alias
[ -f /usr/share/applications/wireshark.desktop ] &&  rm -f /usr/share/applications/mandriva*wireshark.desktop 2>/dev/null
[ -f /usr/bin/wireshark-gtk ] ||  rm -f /usr/share/applications/wireshark-gtk.desktop 2>/dev/null
