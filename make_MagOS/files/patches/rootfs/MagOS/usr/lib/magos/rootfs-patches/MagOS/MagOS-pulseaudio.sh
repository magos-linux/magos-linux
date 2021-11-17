#!/bin/bash
[ -d /etc/sound/profiles/pulse ] && alternatives --set soundprofile /etc/sound/profiles/pulse >/dev/null 2>&1
PFP=/etc/pulse/client.conf
[ -f $PFP ] || exit 0
sed -i 's|^.*autospawn.*$|autospawn = yes|' $PFP
grep -q "autospawn = yes" $PFP || echo "autospawn = yes" >> $PFP
exit 0
