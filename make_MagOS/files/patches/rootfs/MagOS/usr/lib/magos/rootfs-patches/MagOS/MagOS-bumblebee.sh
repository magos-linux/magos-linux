#!/bin/bash
PFP=/etc/bumblebee/bumblebee.conf
sed -i s/^Driver=.*$/Driver=nvidia/ $PFP
sed -i s/^KernelDriver=nvidi.*$/KernelDriver=nvidia-current/ $PFP
sed -i s/'#[[:space:]]*BusID "PCI:'/'    BusID "PCI:'/ /etc/bumblebee/xorg.conf.nouveau
sed -i s/'#[[:space:]]*BusID "PCI:'/'    BusID "PCI:'/ /etc/bumblebee/xorg.conf.nvidia
exit 0
