#!/bin/bash
[ ! -f /usr/bin/startkde -o -d /etc/xdg/plasma-workspace ] && exit 0
ln -sf /usr/share/magos/kde4/kde4rc                        /etc/alternatives/kde4-config
ln -sf /usr/share/magos/kde4/share/config/kdm/backgroundrc /etc/alternatives/kdm4-background-config
ln -sf /usr/share/magos/kde4/share/config/kdm/kdmrc        /etc/alternatives/kdm4-config

#Default wallpaper
if [ -d /usr/share/apps/desktoptheme ] ;then
 for a in /usr/share/apps/desktoptheme/* ;do
  if [ -f "$a/metadata.desktop" ] ;then
    if ! grep -q "defaultWallpaperTheme" "$a/metadata.desktop" ;then
       echo -e  "\n[Wallpaper]\ndefaultWallpaperTheme=/usr/share/magos/wallpapers/default.jpg" >> "$a/metadata.desktop"
    else
       sed -i 's|defaultWallpaperTheme=.*|defaultWallpaperTheme=/usr/share/magos/wallpapers/default.jpg|' "$a/metadata.desktop"
    fi
  fi
 done
fi

exit 0
