#!/bin/bash
sed -i s%'\[\[ "$UTC" == "false" || "$UTC" == "no" \]\]'%'\[ "$UTC" = "false" -a "$TOUCHDEV" = "yes" \]'% sbin/start_udev
