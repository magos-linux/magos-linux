#!/bin/bash
[ -f /etc/rosa-release ] || exit 0

if [ -d /usr/share/mdk/about ] ;then
  ln -sf /usr/share/magos/about/index-ru-magos.html /usr/share/mdk/about/index-ru.html
  ln -sf /usr/share/magos/about/index-ru-magos.html /usr/share/mdk/about/index.html
fi
ln -sf /usr/share/magos/screensaver/Default       /usr/share/mdk/screensaver
ln -sf /usr/share/magos/wallpapers                /usr/share/mdk/backgrounds
ln -sf magos.png                                  /usr/share/icons/mandriva.png
ln -sf magos.png                                  /usr/share/icons/mandriva-button-lxde.png
#Firefox bookmarks
#ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html /usr/share/mdk/bookmarks/mozilla/mozilla-download.html
#ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html /usr/share/mdk/bookmarks/mozilla/mozilla-one.html
#ln -sf /usr/share/magos/bookmarks/magos-bookmarks.html /usr/share/mdk/bookmarks/mozilla/mozilla-powerpack.html

#Disable unmounting nfs livemedia
sed -i s='if \[\[ "$rootfs"'='if grep -q " /mnt/livemedia nfs " /proc/mounts || \[\[ "$rootfs"'= /etc/rc.d/init.d/network

PFP=/var/lib/mandriva/kde4-profiles/Default/kde4rc
[ -f $PFP ] && sed -i 's|^prefixes=.*|prefixes=/var/lib/mandriva/kde4-profiles/common,/var/lib/mandriva/kde4-profiles/Default,/usr/share/magos/kde4|' $PFP

[ -d /usr/share/icons/rosa -a ! -d /usr/share/icons/rosa-flat ] && ln -sf rosa /usr/share/icons/rosa-flat

PFP=/var/lib/mandriva/kde4-profiles/common/share/config/kickoffrc
[ -f $PFP ] && sed -i 's|,/usr/share/applications/kde4/kopete.desktop||' $PFP

PFP=/usr/share/mdk/dm/mdk-gdm-nolist.xml
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/default.jpg=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/usr/share/mdk/dm/mdk-gdm.xml
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/default.jpg=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/usr/share/mdk/dm/mdk-kde-nolist.xml
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/default.png=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/usr/share/mdk/dm/mdk-kde.xml
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/default.png=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/var/lib/mandriva/kde4-profiles/Default/share/config/kdm/backgroundrc
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/default.png=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/var/lib/mandriva/kde4-profiles/Default/share/config/kdm/themes/mandriva-kde4/mandriva-kde4.xml
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/.*jpg=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/var/lib/mandriva/kde4-profiles/common/share/config/kwinrc
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/.*jpg=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/var/lib/mandriva/kde4-profiles/common/share/config/plasma-desktop-appletsrc
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/.*jpg=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/var/lib/mandriva/kde4-profiles/common/share/apps/desktoptheme/Mandriva/metadata.desktop
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/.*jpg=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/var/lib/mandriva/kde4-profiles/common/share/apps/desktoptheme/Mandriva-netbook/metadata.desktop
[ -f $PFP ] && sed -i s=/usr/share/mdk/backgrounds/.*jpg=/usr/share/magos/wallpapers/default.jpg= $PFP

[ -d /usr/share/pixmaps/splash ] && ln -sf magos-gnome-splash.png /usr/share/pixmaps/splash/mdv-gnome-splash.png

if [ -d /usr/share/mcc/themes/default ] ;then
  ln -sf magos-left-background-filler.png /usr/share/mcc/themes/default/left-background-filler.png
  ln -sf magos-left-background.png        /usr/share/mcc/themes/default/left-background.png
  ln -sf magos-splash_screen.png          /usr/share/mcc/themes/default/splash_screen.png
fi
[ -d /usr/share/compositing-wm ] && ln -sf magos-top.png /usr/share/compositing-wm/mandriva-top.png

PFP=/var/lib/mandriva/kde4-profiles/Default
[ -d var/lib/mandriva/kde4-profiles/flash ] && PFP=/var/lib/mandriva/kde4-profiles/flash
if [ -d $PFP ] ;then
  ln -sf magosbutton.svg $PFP/share/apps/mandriva/pics/mdvbutton.svg
  ln -sf magos-top.svg   $PFP/share/apps/mandriva/pics/top.svg
  ln -sf magosbutton.png $PFP/share/icons/oxygen/256x256/places/mdvbutton.png
  ln -sf magosbutton.png $PFP/share/icons/oxygen/22x22/places/mdvbutton.png
  ln -sf magosbutton.png $PFP/share/icons/oxygen/64x64/places/mdvbutton.png
  ln -sf magosbutton.png $PFP/share/icons/oxygen/128x128/places/mdvbutton.png
  ln -sf magosbutton.png $PFP/share/icons/oxygen/16x16/places/mdvbutton.png
  ln -sf magosbutton.png $PFP/share/icons/oxygen/32x32/places/mdvbutton.png
  ln -sf magosbutton.png $PFP/share/icons/oxygen/48x48/places/mdvbutton.png
  ln -sf magosbutton.svg $PFP/share/icons/oxygen/scalable/mdvbutton.svg
fi

PFP=/usr/share/icons/rosa
if [ -d $PFP ] ;then
   for a in $PFP/*[0-9]x[0-9]* ;do
       [ -d $a/places ] && ln -sf ../../../magos.svg $a/places/start-here.svg
   done
fi

PFP=/etc/xdg/openbox/rc.xml
[ -f $PFP ] && sed -i 's|<name>Clearlooks</name>|<name>Default</name>|' $PFP
PFP=/var/lib/mandriva/kde4-profiles/common/share/config/kwinrc
[ -f $PFP ] && sed -i 's|PluginLib=.*|PluginLib=kwin3_oxygen|' $PFP
PFP=/etc/gconf/gconf.xml.defaults/%gconf-tree.xml
[ -f $PFP ] && sed -i 's|<stringvalue>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</stringvalue>|<stringvalue></stringvalue>|' $PFP
PFP=/etc/gconf/gconf.xml.defaults/%gconf-tree.xml
[ -f $PFP ] && sed -i 's|<stringvalue>Ia Ora Steel</stringvalue>|<stringvalue>Default</stringvalue>|' $PFP
PFP=/etc/gconf/schemas/desktop_gnome_interface.schemas
[ -f $PFP ] && sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' $PFP

exit 0
