#!/bin/bash
rm -f usr/share/autostart/kaddressbookmigrator.desktop usr/share/autostart/kalarm.autostart.desktop \
      usr/share/autostart/konqy_preload.desktop usr/share/autostart/nepomukcontroller.desktop \
      usr/share/autostart/nepomukserver.desktop 2>/dev/null
ln -sf /usr/share/magos/kde4/kde4rc etc/alternatives/kde4-config
ln -sf /usr/share/magos/kde4/share/config/kdm/backgroundrc  etc/alternatives/kdm4-background-config
ln -sf /usr/share/magos/kde4/share/config/kdm/kdmrc etc/alternatives/kdm4-config
#sed -i 's|^prefixes=.*|prefixes=/var/lib/mandriva/kde4-profiles/common,/var/lib/mandriva/kde4-profiles/Default,/usr/share/magos/kde4|' etc/alternatives/kde4-config
sed -i 's|^prefixes=.*|prefixes=/var/lib/mandriva/kde4-profiles/common,/var/lib/mandriva/kde4-profiles/Default,/usr/share/magos/kde4|' var/lib/mandriva/kde4-profiles/Default/kde4rc
exit 0
