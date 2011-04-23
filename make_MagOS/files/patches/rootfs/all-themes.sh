#!/bin/bash

sed -i 's|<stringvalue>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</stringvalue>|<stringvalue></stringvalue>|' etc/gconf/gconf.xml.defaults/%gconf-tree.xml
sed -i 's|<stringvalue>Ia Ora Steel</stringvalue>|<stringvalue>Default</stringvalue>|' etc/gconf/gconf.xml.defaults/%gconf-tree.xml
sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' etc/gconf/schemas/desktop_gnome_interface.schemas
sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' etc/gconf/schemas/metacity.schemas
sed -i 's|<string>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</string>|<string></string>|' etc/gconf/schemas/panel-default-setup.entries
sed -i 's|PluginLib=kwin3_iaora|PluginLib=kwin3_oxygen|' var/lib/mandriva/kde4-profiles/common/share/config/kwinrc
sed -i 's|<name>Clearlooks</name>|<name>Default</name>|' etc/xdg/openbox/rc.xml

DIRGTK=gtk-2.0
DIRMETACITY=metacity-1
DIROPENBOX=openbox-3
rm -fr "usr/share/themes/Default/$DIRGTK" "usr/share/themes/Default/$DIRMETACITY" "usr/share/themes/Default/$DIROPENBOX"
ln -sf "../MagOS/$DIRGTK"  "usr/share/themes/Default/$DIRGTK"
ln -sf "../MagOS/$DIRMETACITY" "usr/share/themes/Default/$DIRMETACITY"
ln -sf "../MagOS/$DIROPENBOX" "usr/share/themes/Default/$DIROPENBOX"
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

sed -i s/'color="#[fF][fF][fF][fF][fF][fF]"'/'color="#000000"'/ usr/share/apps/kdm/themes/mandriva-kde4/mandriva-kde4.xml
sed -i s/'color="#......" alpha'/'color="#FFFFFF" alpha'/ usr/share/apps/kdm/themes/mandriva-kde4/mandriva-kde4.xml
sed -i s/'alpha="0[.][0-9]'/'alpha="0.5'/ usr/share/apps/kdm/themes/mandriva-kde4/mandriva-kde4.xml

sed -i s/'color="#[fF][fF][fF][fF][fF][fF]"'/'color="#000000"'/ usr/share/mdk/dm/mdk-gdm.xml
sed -i s/'color="#......" alpha'/'color="#FFFFFF" alpha'/ usr/share/mdk/dm/mdk-gdm.xml
sed -i s/'alpha="0[.][0-9]'/'alpha="0.5'/ usr/share/mdk/dm/mdk-gdm.xml

sed -i s/^msg_color.*$/'msg_color               #000000'/ usr/share/slim/themes/default/slim.theme

exit 0
