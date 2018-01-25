#!/bin/bash

mkdir -p /usr/share/backgrounds
ln -sf /usr/share/magos/wallpapers/Default     /usr/share/backgrounds/gnome

DIRGTK=gtk-2.0
DIRGTK3=gtk-3.0
DIRMETACITY=metacity-1
ln -sf "../MagOS/$DIRGTK"      "/usr/share/themes/Default/$DIRGTK"
ln -sf "../MagOS/$DIRGTK3"     "/usr/share/themes/Default/$DIRGTK3"
ln -sf "../MagOS/$DIRMETACITY" "/usr/share/themes/Default/$DIRMETACITY"
#ln -sf "/usr/share/themes/Default/$DIRGTK/gtkrc"  "/etc/$DIRGTK/gtkrc"
#ln -sf "/usr/share/themes/Default/$DIRGTK/apps"   "/etc/$DIRGTK/apps"
#ln -sf "/usr/share/themes/Default/$DIRGTK/images" "/etc/$DIRGTK/images"

#may be obsolete
#find /usr/share/themes | grep gtk-2.0/gtkrc$ | while read a ;do
#    grep -q color_scroll "$a" && continue
#    sed -i '1s/^/gtk_color_scheme = "color_scroll:#111111"\n/' "$a"
#done
#change theme

DEFTHEME=Adwaita
PFP=/usr/share/glib-2.0/schemas/org.gnome.desktop.background.gschema.xml
[ -f $PFP ] && sed -i s=/usr/share/themes/$DEFTHEME/backgrounds/.*xml=/usr/share/magos/wallpapers/default.jpg= $PFP
PFP=/usr/share/glib-2.0/schemas/org.gnome.desktop.wm.preferences.gschema.xml
[ -f $PFP ] && sed -i s=$DEFTHEME=Default= $PFP
PFP=/usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.xml
[ -f $PFP ] && sed -i s=$DEFTHEME=Default= $PFP
glib-compile-schemas /usr/share/glib-2.0/schemas

exit 0
