#!/bin/bash
for a in MagOS MagOS-dark MagOS-green ;do
   [ -d /usr/share/themes/$a/gtk-3.20 ] || continue
   rm -f /usr/share/themes/$a/gtk-3.0
   ln -sf gtk-3.20 /usr/share/themes/$a/gtk-3.0
done
exit 0