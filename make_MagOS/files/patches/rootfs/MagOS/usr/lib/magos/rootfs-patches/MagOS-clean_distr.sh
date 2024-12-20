#!/bin/bash

rm -fr 2>/dev/null \
   etc/skel/tmp var/tmp proc sys tmp etc/fstab etc/mtab \
   boot/initrd* boot/initramfs* \
   etc/locale usr/share/locale/locale-archive usr/lib/locale/locale-archive \
   etc/machine-id var/lib/dbus/machine-id \
   etc/modprobe.d/nvidia[0-9]* etc/modprobe.d/nvidia*-blacklist-nouveau.conf \
   etc/X11/xorg.conf etc/X11/xorg.conf.d/*nvidia* etc/adjtime etc/localtime \
   etc/xdg/autostart/parcellite-startup.desktop \
   etc/xdg/autostart/org.kde.kgpg.desktop \
   etc/xdg/autostart/lxqt-xscreensaver-autostart.desktop \
   etc/xdg/autostart/hplip-systray.desktop \
   etc/xdg/plasma-workspace/env/gtk*.sh \
   etc/xdg/kxkbrc \
   usr/share/GeoIP/GeoLiteCity.dat \
   usr/share/apps/kio_desktop/DesktopLinks/* \
   usr/share/applications/gscriptor.desktop \
   usr/share/doc/rosa-media-player/*.jpg usr/share/vpnpptp/wiki/*_uk.doc \
   usr/share/doc/proftpd/Configuration.pdf usr/share/doc/easytag/users_* usr/share/doc/easytag/*_Documentation_* \
   usr/share/doc/djvulibre/doc usr/share/doc/initscripts/ChangeLog* usr/share/doc/libglib2.0-devel/ChangeLog \
   usr/share/doc/plasma-applet-stackfolder usr/share/doc/glibc/ChangeLog* \
   usr/share/doc/HTML/ru/marble usr/share/doc/HTML/ru/kalzium usr/share/doc/HTML/ru/kigo \
   usr/share/doc/HTML/ru/kstars usr/share/doc/HTML/ru/kbruch usr/share/doc/HTML/ru/akregator \
   usr/share/help/C/cheese/figures/effects.png \
   usr/share/doc/perl-Libconf/html/Libconf/Libconf \
   usr/share/backgrounds/gnome usr/share/backgrounds/mate /usr/share/backgrounds/cosmos \
   usr/share/xsessions/openbox*.desktop usr/share/kio_desktop/DesktopLinks/* \
   usr/share/sddm/themes/elarun/images/background.png
#   etc/samba/passdb.tdb etc/samba/secrets.tdb \
#   usr/share/GeoIP/GeoLiteCity.dat 2>/dev/null


#wallpapers
[ -d usr/share/wallpapers ] && for a in usr/share/wallpapers/* ;do [ -d "$a" ] && rm -fr "$a" ; done

#Kill big icons to save some space
[ -d usr/share/icons ] && for a in `find usr/share/icons -type d | grep -E -e '[x/]512$|[x/]256$|/128x128$' ` ;do  rm -fr "$a" ; done

#KDE
rm -fr 2>/dev/null usr/share/autostart/kaddressbookmigrator.desktop \
  usr/share/autostart/kalarm.autostart.desktop \
  usr/share/autostart/konqy_preload.desktop \
  usr/share/autostart/nepomukcontroller.desktop \
  usr/share/autostart/nepomukserver.desktop \
  usr/share/apps/ksplash/Themes

#openbox
rm -fr 2>/dev/null "usr/share/themes/Default/openbox-3"

#emerald
rm -fr 2>/dev/null usr/share/emerald/theme

#harddrake
rm -f 2>/dev/null etc/sysconfig/harddrake2/previous_hw

#GTK themes
DIRGTK=gtk-2.0
DIRGTK3=gtk-3.0
DIRMETACITY=metacity-1
rm -fr 2>/dev/null "usr/share/themes/Default/$DIRGTK" "usr/share/themes/Default/$DIRGTK3" "usr/share/themes/Default/$DIRMETACITY"
rm -fr 2>/dev/null "etc/$DIRGTK/gtkrc" "etc/$DIRGTK/apps" "etc/$DIRGTK/images"

#pulseaudio
rm -f 2>/dev/null etc/alternatives/soundprofile etc/xdg/autostart/pulseaudio.desktop

#Rosa
rm -fr 2>/dev/null usr/share/mdk/desktop/free/* usr/share/mdk/screensaver usr/share/mdk/backgrounds \
   usr/lib/drakx-installer-stage2/install/stage2/mdkinst.sqfs \
   usr/share/mdk/desktop/free/* usr/share/mdk/desktop/one/*  usr/share/mdk/desktop/powerpack/* \
   var/lib/mandriva/kde4-profiles/Default/share/apps/ksplash/Themes
[ -d usr/share/icons/rosa -a -d usr/share/icons/rosa-flat ] && rm -fr usr/share/icons/rosa-flat

#meta
rm -f usr/share/kservices5/searchproviders/facebook.desktop
find usr/share/icons | grep -i facebook | xargs rm -f

exit 0
