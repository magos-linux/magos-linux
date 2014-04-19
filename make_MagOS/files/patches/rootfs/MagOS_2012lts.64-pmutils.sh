#!/bin/bash
PMUP=usr/lib/pm-utils
[ -f usr/lib/pm-utils/pm-functions ] || PMUP=usr/lib64/pm-utils
PFP=$PMUP/pm-functions
[ -f $PFP ] || exit 0
grep -q MagOS $PFP || sed -i /^RESUME_DEV=/s%$%'\n #MagOS patch\
[ -z $RESUME_DEV ] \&\& RESUME_DEV=$(blkid | grep -m1 swap | awk -F: '\''{print $1}'\'') \
[ -z $RESUME_DEV ] \&\& RESUME_DEV=$(blkid | grep -m1 swsuspend | awk -F: '\''{print $1}'\'') \&\& /'$PMUP'/bin/pm-reset-swap $RESUME_DEV \
[ -z $RESUME_DEV ] || swapon -s | grep -q $RESUME_DEV || swapon  $RESUME_DEV'% $PFP
