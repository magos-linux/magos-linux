#!/bin/bash
sed -i /^RESUME_DEV=/s%$%'\n[ -z $RESUME_DEV ] && RESUME_DEV=$(blkid | grep -m1 swap | awk -F: '\''{print $1}'\'') \
[ -z $RESUME_DEV ] && RESUME_DEV=$(blkid | grep -m1 swsuspend | awk -F: '\''{print $1}'\'') && /usr/lib/pm_utils/bin/pm-reset-swap $RESUME_DEV \
[ -z $RESUME_DEV ] || swapon -s | grep -q $RESUME_DEV || swapon  $RESUME_DEV'% usr/lib/pm-utils/pm-functions
