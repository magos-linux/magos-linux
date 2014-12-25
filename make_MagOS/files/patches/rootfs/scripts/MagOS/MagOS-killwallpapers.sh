#!/bin/bash
for a in usr/share/wallpapers/* ;do
    [ -d "$a" ] && rm -fr "$a"
done

find usr/share/apps/ksplash/Themes/Default -name background.png 2>/dev/null | grep -v 1600x1200 | xargs rm -f 
[ -d usr/share/apps/ksplash/Themes/Horos ] && cp -p usr/share/apps/ksplash/Themes/Horos/1600x1200/* usr/share/apps/ksplash/Themes/Default/1600x1200
rm -fr usr/share/apps/ksplash/Themes/Horos usr/share/apps/ksplash/Themes/ROSA \
       var/lib/mandriva/kde4-profiles/Default/share/apps/ksplash/Themes 2>/dev/null
