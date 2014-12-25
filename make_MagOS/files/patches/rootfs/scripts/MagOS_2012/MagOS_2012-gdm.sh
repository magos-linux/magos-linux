#!/bin/bash
PFP=usr/share/gdm/gdm.schemas
for a in nx pdnsd sshd openvpnd ; do
  grep -q root,.*$a, $PFP || sed -i s/root,/root,$a,/ $PFP
done
mkdir -p var/lib/gdm/.config/gnome-session 
chroot . chown -R gdm:gdm /var/lib/gdm/.config/gnome-session
exit 0

#FIX - Disable pulseaudio in GDM3
sed -i "s|autoaudiosink|alsasink|g" etc/gconf/schemas/gstreamer-0.10.schemas etc/gconf/gconf.xml.defaults/%gconf-tree.xml
chroot . gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory --type Boolean --set /apps/gdm/simple-greeter/settings-manager-plugins/sound/active False
mkdir -p var/lib/gdm/.config/gnome-session var/lib/gdm/.pulse/
cat > var/lib/gdm/.pulse/client.conf << EOF
autospawn = no
daemon-binary = /bin/true
EOF
chroot . chown -R gdm:gdm /var/lib/gdm
