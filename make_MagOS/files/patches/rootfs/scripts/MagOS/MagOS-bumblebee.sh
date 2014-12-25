#!/bin/bash
PFP=etc/bumblebee/bumblebee.conf
sed -i s/^Driver=.*$/Driver=nvidia/ $PFP
sed -i s/^KernelDriver=$/KernelDriver=nvidia-current/ $PFP
exit 0
