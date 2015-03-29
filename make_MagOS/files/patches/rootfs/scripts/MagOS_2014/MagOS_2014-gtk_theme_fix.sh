#!/bin/bash
#may be obsolete
find usr/share/themes | grep gtk-2.0/gtkrc$ | while read a ;do
    grep -q color_scroll "$a" && continue
    sed -i '1s/^/gtk_color_scheme = "color_scroll:#111111"\n/' "$a"
done
#change theme
PFP=etc/gtk-3.0/settings.ini
[ -f $PFP ] && sed -i s/"gtk-theme-name =".*/"gtk-theme-name = Default"/ $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.background.gschema.xml
[ -f $PFP ] && sed -i s=usr/share/themes/Adwaita/backgrounds/adwaita-timed.xml=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.wm.preferences.gschema.xml
[ -f $PFP ] && sed -i s=Adwaita=Default= $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.xml
[ -f $PFP ] && sed -i s=Adwaita=Default= $PFP
chroot . glib-compile-schemas /usr/share/glib-2.0/schemas
