#!/bin/bash
PFP=etc/sudoers
sed -i s/'^Defaults.*requiretty'/'#Defaults    requiretty'/ $PFP
exit 0
