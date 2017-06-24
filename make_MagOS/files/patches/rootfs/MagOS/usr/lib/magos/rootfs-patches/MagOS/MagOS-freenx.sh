#!/bin/sh
[ -f /usr/bin/nxserver ] || exit 0
chown -R nx.root /etc/nxserver
chown -R nx.root /var/lib/nxserver
passwd -uf nx >/dev/null 2>&1
date +%N | md5sum | cut -c 1-16  > nx.pass
passwd -f --stdin nx <nx.pass >/dev/null 2>&1
rm -f nx.pass
#BUGFIX
#grep -q 'COMMAND_NETCAT 2>/dev/null' /usr/bin/nxserver || sed -i 's|COMMAND_NETCAT|COMMAND_NETCAT 2>/dev/null|' /usr/bin/nxserver
#LXDE & GNOME FAILURE BUGFIX
#PFP=etc/nxserver/node.conf
#sed -i s/.*AGENT_EXTRA_OPTIONS_X=.*/'AGENT_EXTRA_OPTIONS_X="-norender"'/ $PFP
exit 0
