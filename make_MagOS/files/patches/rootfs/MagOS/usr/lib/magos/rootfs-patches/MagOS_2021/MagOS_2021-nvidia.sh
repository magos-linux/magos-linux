#!/bin/bash

PFP=/usr/share/magos/hwdata/xdriver/nvidia390

mkdir -p $(dirname $PFP)

echo "8086:0416" >>$PFP

exit 0
