#!/bin/bash
alternatives --set soundprofile /etc/sound/profiles/pulse >/dev/null
PFP=/etc/pulse/client.conf
sed -i 's|^.*autospawn.*$|autospawn = yes|' $PFP
grep -q "autospawn = yes" $PFP || echo "autospawn = yes" >> $PFP
exit 0
