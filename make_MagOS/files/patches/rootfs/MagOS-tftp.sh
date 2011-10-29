#!/bin/bash
PFP=etc/xinetd.d/tftp
sed -i s%server_args.*%'server_args             = -s /boot'% $PFP
exit 0
