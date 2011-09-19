#!/bin/bash
PFP=etc/xinetd.d/tftp
sed -i s%server_args.*%'server_args             = -s /mnt/livemedia'% $PFP
exit 0
