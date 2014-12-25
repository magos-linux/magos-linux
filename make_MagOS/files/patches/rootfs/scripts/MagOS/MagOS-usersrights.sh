#!/bin/bash
#FIXME - obsolete
sed -i 's|GROUP="sound"|GROUP="users"|' lib/udev/rules.d/50-udev-default.rules
sed -i 's|GROUP="video"|GROUP="users"|' lib/udev/rules.d/50-udev-default.rules
sed -i 's|GROUP="cdrom"|GROUP="users"|' lib/udev/rules.d/50-udev-default.rules
sed -i 's|GROUP="cdwriter"|GROUP="users"|' lib/udev/rules.d/50-udev-default.rules
sed -i 's|GROUP="floppy"|GROUP="users"|' lib/udev/rules.d/50-udev-default.rules
sed -i 's|GROUP="audio"|GROUP="users"|' lib/udev/rules.d/50-udev-mandriva.rules
sed -i 's|GROUP="video"|GROUP="users"|' lib/udev/rules.d/50-udev-mandriva.rules
sed -i 's|GROUP="cdrom"|GROUP="users"|' lib/udev/rules.d/50-udev-mandriva.rules
sed -i 's|GROUP="cdwriter"|GROUP="users"|' lib/udev/rules.d/50-udev-mandriva.rules
sed -i 's|GROUP="floppy"|GROUP="users"|' lib/udev/rules.d/50-udev-mandriva.rules
