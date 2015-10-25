#!/bin/bash
#Disable unmounting nfs livemedia
sed -i s='if \[\[ "$rootfs"'='if grep -q " /mnt/livemedia nfs " /proc/mounts || \[\[ "$rootfs"'= etc/rc.d/init.d/network

#Default runlevel
[ -f etc/inittab ] && sed -i s/":3:initdefault:"/":5:initdefault:"/ etc/inittab

#Realtime settings
PFP=etc/sysctl.conf
[ -d /etc/sysctl.d ] && PFP=/etc/sysctl.d/magos.conf
grep -q vm.swappiness $PFP 2>/dev/null || echo -e "\n# Realtime settings\nvm.swappiness=10" >> $PFP
grep -q fs.inotify.max_user_watches $PFP || echo "fs.inotify.max_user_watches = 524288" >> $PFP
PFP=etc/security/limits.conf
sed -i s/.audio.*rtprio.*/'@audio          -       rtprio           90'/ $PFP
grep -q audio.*memlock $PFP || sed -i /audio.*rtprio/s/$/'\n@audio          -       memlock          unlimited'/ $PFP
sed -i s/.audio.*memlock.*/'@audio          -       memlock          unlimited'/ $PFP

#Disable pulse and switch on alsa
rm -f etc/alternatives/soundprofile
ln -sf /etc/sound/profiles/alsa etc/alternatives/soundprofile
PFP=etc/pulse/client.conf
grep -q ^autospawn $PFP || echo "autospawn = no" >>$PFP

exit 0
