#!/bin/bash
rm -fr usr/share/themes/Default/gtk-3.0
sed -i s/"gtk-theme-name =".*/"gtk-theme-name = Default"/ etc/gtk-3.0/settings.ini
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.background.gschema.xml
sed -i s=usr/share/themes/Adwaita/backgrounds/adwaita-timed.xml=usr/share/mdk/backgrounds/default.jpg= $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.wm.preferences.gschema.xml
sed -i s=Adwaita=Default= $PFP
PFP=usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.xml
sed -i s=Adwaita=Default= $PFP
chroot . glib-compile-schemas /usr/share/glib-2.0/schemas
PFP=etc/gnome/gnomerc
#BUGFIX http://bugs.rosalinux.ru/show_bug.cgi?id=1893
if ! grep -q gnome-session.*SESSION_ARGS $PFP ;then
   sed -i s=gnome-session='gnome-session $SESSION_ARGS'= $PFP
fi

chroot . chksession -K
chroot . chksession -g
#rm -f etc/X11/dm/Sessions/02GNOME.desktop usr/share/apps/kdm/sessions/02GNOME.desktop 2>/dev/null

PFP=usr/share/gnome-panel/panel-default-layout.layout
grep -q alsamixer $PFP || cat >>$PFP  <<EOF

[Object alsamixer]
object-iid=PanelInternalFactory::Launcher
toplevel-id=top-panel
pack-type=end
pack-index=2
@instance-config/location="file:///usr/share/applications/mandriva-gnome-alsamixer.desktop"

[Object firefox]
object-iid=PanelInternalFactory::Launcher
toplevel-id=top-panel
pack-type=start
pack-index=1
@instance-config/location="file:///usr/share/applications/firefox.desktop"

[Object thunderbird]
object-iid=PanelInternalFactory::Launcher
toplevel-id=top-panel
pack-type=start
pack-index=2
@instance-config/location="file:///usr/share/applications/mandriva-mozilla-thunderbird.desktop"

[Object gcalctool]
object-iid=PanelInternalFactory::Launcher
toplevel-id=top-panel
pack-type=start
pack-index=3
@instance-config/location="file:///usr/share/applications/gcalctool.desktop"
EOF
