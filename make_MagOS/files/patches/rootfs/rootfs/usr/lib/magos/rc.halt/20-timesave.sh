#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

#Setting clock
. /etc/sysconfig/clock
HWCLOCKOPIONS="--utc"
[ "$UTC" = "false" ] && HWCLOCKOPIONS="--localtime"
hwclock -w $HWCLOCKOPIONS