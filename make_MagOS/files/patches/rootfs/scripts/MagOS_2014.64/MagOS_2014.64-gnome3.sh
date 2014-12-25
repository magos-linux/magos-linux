#!/bin/bash
PFP=etc/gtk-3.0/settings.ini
[ -f $PFP ] && sed -i s/"gtk-theme-name =".*/"gtk-theme-name = Default"/ $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.background.gschema.xml
[ -f $PFP ] && sed -i s=usr/share/themes/Adwaita/backgrounds/adwaita-timed.xml=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.wm.preferences.gschema.xml
[ -f $PFP ] && sed -i s=Adwaita=Default= $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.xml
[ -f $PFP ] && sed -i s=Adwaita=Default= $PFP
chroot . glib-compile-schemas /usr/share/glib-2.0/schemas
#PFP=etc/gnome/gnomerc
#BUGFIX http://bugs.rosalinux.ru/show_bug.cgi?id=1893
#if ! grep -q gnome-session.*SESSION_ARGS $PFP ;then
#   sed -i s=gnome-session='gnome-session $SESSION_ARGS'= $PFP
#fi

chroot . chksession -K
chroot . chksession -g
#rm -f etc/X11/dm/Sessions/02GNOME.desktop usr/share/apps/kdm/sessions/02GNOME.desktop 2>/dev/null

