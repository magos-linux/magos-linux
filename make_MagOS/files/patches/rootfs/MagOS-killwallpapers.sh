#!/bin/bash
for a in usr/share/wallpapers/* ;do
    [ -d "$a" ] && rm -fr "$a"
done

rm -f usr/share/mdk/backgrounds/nature.jpg usr/share/mdk/backgrounds/flower.jpg
for a in usr/share/mdk/backgrounds/Mandriva-*.jpg ;do
    [ -e "$a" ] || continue
    ln -sf default.jpg "$a"
done

#Mandriva
[ -f usr/share/wallpapers/default_blue.jpg ] && ln -sf /usr/share/wallpapers/default_blue.jpg usr/share/mdk/backgrounds/default.jpg
#Rosa
[ -f usr/share/mdk/backgrounds/rosa-background.jpg ] && ln -sf rosa-background.jpg usr/share/mdk/backgrounds/default.jpg

find usr/share/apps/ksplash/Themes/Default -name background.png | grep -v 1600x1200 | xargs rm -f 

[ -d usr/share/apps/ksplash/Themes/Horos ] && cp -p usr/share/apps/ksplash/Themes/Horos/1600x1200/* usr/share/apps/ksplash/Themes/Default/1600x1200

rm -fr usr/share/apps/ksplash/Themes/Horos \
       usr/share/apps/ksplash/Themes/ROSA \
       usr/share/backgrounds/gnome \
       var/lib/mandriva/kde4-profiles/Default/share/apps/ksplash/Themes 2>/dev/null

ln -sf /usr/share/magos/wallpappers usr/share/backgrounds/gnome 2>/dev/null
