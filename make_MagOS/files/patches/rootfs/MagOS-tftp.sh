#!/bin/bash
PFP=etc/xinetd.d/tftp
[ -f $PFP ] || exit 0
sed -i s%server_args.*%'server_args             = -s /boot'% $PFP
exit 0
