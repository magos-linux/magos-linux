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
