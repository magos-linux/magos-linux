#!/bin/bash
sed -i s/'color="#[fF][fF][fF][fF][fF][fF]"'/'color="#000000"'/ usr/share/apps/kdm/themes/mandriva-kde4/mandriva-kde4.xml
sed -i s/'color="#......" alpha'/'color="#FFFFFF" alpha'/ usr/share/apps/kdm/themes/mandriva-kde4/mandriva-kde4.xml
sed -i s/'alpha="0[.][0-9]'/'alpha="0.5'/ usr/share/apps/kdm/themes/mandriva-kde4/mandriva-kde4.xml

sed -i s/'color="#[fF][fF][fF][fF][fF][fF]"'/'color="#000000"'/ usr/share/mdk/dm/mdk-gdm.xml
sed -i s/'color="#......" alpha'/'color="#FFFFFF" alpha'/ usr/share/mdk/dm/mdk-gdm.xml
sed -i s/'alpha="0[.][0-9]'/'alpha="0.5'/ usr/share/mdk/dm/mdk-gdm.xml

exit 0
