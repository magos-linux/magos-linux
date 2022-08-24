#!/bin/bash
PFP=/etc/bumblebee/bumblebee.conf
sed -i s/^Driver=.*$/Driver=nvidia/ $PFP
sed -i s/^KernelDriver=nvidi.*$/KernelDriver=nvidia-current/ $PFP
sed -i s/'#[[:space:]]*BusID "PCI:'/'    BusID "PCI:'/ /etc/bumblebee/xorg.conf.nouveau
sed -i s/'#[[:space:]]*BusID "PCI:'/'    BusID "PCI:'/ /etc/bumblebee/xorg.conf.nvidia
for a in $(find /usr/lib/ -type d -name nvidia*) $(find /usr/lib64/ -type d -name nvidia*) ;do
   [ -f $a/libGL.so.1 ] || ln -sf ../libGL.so.1 $a
done
exit 0
