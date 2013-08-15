#!/bin/bash
ln -sf magos-top.png usr/share/compositing-wm/mandriva-top.png
ln -sf magos.png usr/share/icons/mandriva.png
ln -sf magos.png usr/share/icons/mandriva-button-lxde.png
ln -sf magos-left-background-filler.png usr/share/mcc/themes/default/left-background-filler.png
ln -sf magos-left-background.png usr/share/mcc/themes/default/left-background.png
ln -sf magos-splash_screen.png usr/share/mcc/themes/default/splash_screen.png
ln -sf magos-gnome-splash.png usr/share/pixmaps/splash/mdv-gnome-splash.png

PFP=var/lib/mandriva/kde4-profiles/Default
[ -d var/lib/mandriva/kde4-profiles/flash ] && PFP=var/lib/mandriva/kde4-profiles/flash
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

sed -i 's|<name>Clearlooks</name>|<name>Default</name>|' etc/xdg/openbox/rc.xml
sed -i 's|PluginLib=.*|PluginLib=kwin3_oxygen|' var/lib/mandriva/kde4-profiles/common/share/config/kwinrc
sed -i 's|<stringvalue>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</stringvalue>|<stringvalue></stringvalue>|' etc/gconf/gconf.xml.defaults/%gconf-tree.xml
sed -i 's|<stringvalue>Ia Ora Steel</stringvalue>|<stringvalue>Default</stringvalue>|' etc/gconf/gconf.xml.defaults/%gconf-tree.xml
sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' etc/gconf/schemas/desktop_gnome_interface.schemas
#2012lts gnome theme patch
PFP=etc/gconf/schemas/metacity.schemas
[ -f $PFP ] && sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' $PFP
[ -f $PFP ] && sed -i 's|<default>elementary</default>|<default>Default</default>|' $PFP
PFP=etc/gconf/schemas/panel-default-setup.entries
[ -f $PFP ] && sed -i 's|<string>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</string>|<string></string>|' $PFP

DIRGTK=gtk-2.0
DIRGTK3=gtk-3.0
DIRMETACITY=metacity-1
DIROPENBOX=openbox-3
rm -fr "usr/share/themes/Default/$DIRGTK" "usr/share/themes/Default/$DIRMETACITY" "usr/share/themes/Default/$DIROPENBOX"
ln -sf "../MagOS/$DIRGTK"  "usr/share/themes/Default/$DIRGTK"
ln -sf "../MagOS/$DIRGTK3"  "usr/share/themes/Default/$DIRGTK3"
ln -sf "../MagOS/$DIRMETACITY" "usr/share/themes/Default/$DIRMETACITY"
ln -sf "../MagOS/$DIROPENBOX" "usr/share/themes/Default/$DIROPENBOX"
rm -fr "etc/$DIRGTK/gtkrc" "etc/$DIRGTK/apps" "etc/$DIRGTK/images" 2>/dev/null
ln -sf "/usr/share/themes/Default/$DIRGTK/gtkrc"  "etc/$DIRGTK/gtkrc"
ln -sf "/usr/share/themes/Default/$DIRGTK/apps"   "etc/$DIRGTK/apps"
ln -sf "/usr/share/themes/Default/$DIRGTK/images" "etc/$DIRGTK/images"
rm -f usr/share/emerald/theme/*
cp -pf usr/share/emerald/themes/MagOS/* usr/share/emerald/theme

for a in usr/share/apps/desktoptheme/* ;do
  if [ -f "$a/metadata.desktop" ] ;then
    if ! grep -q "defaultWallpaperTheme" "$a/metadata.desktop" ;then
       echo -e  "\n[Wallpaper]\ndefaultWallpaperTheme=/usr/share/mdk/backgrounds/default.jpg" >> "$a/metadata.desktop"
    else
       sed -i 's|defaultWallpaperTheme=.*|defaultWallpaperTheme=/usr/share/mdk/backgrounds/default.jpg|' "$a/metadata.desktop"
    fi
  fi
done

sed -i s/^msg_color.*$/'msg_color               #000000'/ usr/share/slim/themes/default/slim.theme

PFP=etc/xdg/lxsession/LXDE/desktop.conf
sed -i s%sNet/ThemeName=.*%sNet/ThemeName=elementary% $PFP
sed -i s%sNet/IconThemeName=.*%sNet/IconThemeName=elementary% $PFP
sed -i s%sGtk/CursorThemeName=.*%sGtk/CursorThemeName=elementary% $PFP

exit 0
