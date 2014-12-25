#!/bin/bash
#may be obsolete for 2012*
find usr/share/themes | grep gtk-2.0/gtkrc$ | while read a ;do
    grep -q color_scroll "$a" && continue
    sed -i '1s/^/gtk_color_scheme = "color_scroll:#111111"\n/' "$a"
done
