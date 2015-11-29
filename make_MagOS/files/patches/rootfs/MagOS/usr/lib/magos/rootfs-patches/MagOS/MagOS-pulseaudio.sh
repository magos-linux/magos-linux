#!/bin/bash
#Disable pulse and switch on alsa
[ -d /etc/sound/profiles/alsa ] || exit 0
ln -sf /etc/sound/profiles/alsa /etc/alternatives/soundprofile
PFP=/etc/pulse/client.conf
grep -q ^autospawn $PFP || echo "autospawn = no" >>$PFP

exit 0
