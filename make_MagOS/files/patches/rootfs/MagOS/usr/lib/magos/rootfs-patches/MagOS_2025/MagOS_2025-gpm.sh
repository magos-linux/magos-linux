#!/bin/bash
[ -f /usr/lib/systemd/system/gpm.service -a -f /etc/rc.d/init.d/gpm ] && rm -f /etc/rc.d/init.d/gpm
exit 0
