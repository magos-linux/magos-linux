#!/bin/bash
PFP=/etc/bash_completion.d/urpmi
if ! grep -q "urpm2xzm" $PFP ;then
   sed -i s%"urpmi gurpmi rurpmi"$%"urpmi gurpmi rurpmi urpm2pfs urpm2xzm urpm2lzm"% $PFP
   sed -i s%"for everything else as rurpmi"$%"for everything else as rurpmi"\\n'[[ ${COMP_WORDS[0]} == *urpm2pfs ]] \&\& options=\"$options -m --mask -o -n --name -e --erase -r --rpmdb -u --urpmdb -urpmi --urpmi'\"% $PFP
fi

exit 0
