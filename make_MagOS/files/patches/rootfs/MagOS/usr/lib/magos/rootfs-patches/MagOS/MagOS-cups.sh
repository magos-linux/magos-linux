#!/bin/bash
sed -i /PrivateTmp=true/d  /lib/systemd/system/cups.service
[ -x /usr/bin/smbspool -a ! -h /usr/lib/cups/backend/smb ] && ln -sf "../../../bin/smbspool" /usr/lib/cups/backend/smb
exit 0
