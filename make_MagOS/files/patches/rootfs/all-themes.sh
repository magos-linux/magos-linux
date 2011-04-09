#!/bin/bash

sed -i 's|<stringvalue>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</stringvalue>|<stringvalue></stringvalue>|' etc/gconf/gconf.xml.defaults/%gconf-tree
sed -i 's|<stringvalue>Ia Ora Steel</stringvalue>|<stringvalue>Default</stringvalue>|' etc/gconf/gconf.xml.defaults/%gconf-tree
sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' etc/gconf/schemas/desktop_gnome_interface.schemas
sed -i 's|<default>Ia Ora Steel</default>|<default>Default</default>|' etc/gconf/schemas/metacity.schemas
sed -i 's|<string>/usr/share/gnome-panel/pixmaps/mandriva-panel.png</string>|<string></string>|' etc/gconf/schemas/panel-default-setup.entries
sed -i 's|PluginLib=kwin3_iaora|PluginLib=kwin3_oxygen|' var/lib/mandriva/kde4-profiles/common/share/config/kwinrc
sed -i 's|<name>Clearlooks</name>|<name>Default</name>|' etc/xdg/openbox/rc.xml

DIRGTK=gtk-2.0
DIRMETACITY=metacity-1
DIROPENBOX=openbox-3
ln -sf "../MagOS/$DIRGTK"  "usr/share/themes/Default/$DIRGTK"
ln -sf "../MagOS/$DIRMETACITY" "usr/share/themes/Default/$DIRMETACITY"
ln -sf "../MagOS/$DIROPENBOX" "usr/share/themes/Default/$DIROPENBOX"
rm -fr usr/share/emerald/theme
ln -sf "themes/MagOS" usr/share/emerald/theme

exit 0