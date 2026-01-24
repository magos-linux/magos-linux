#!/bin/bash
[ -x /usr/bin/compiz ] || exit 0
PFP=/etc/skel/.config/compiz-1/compizconfig/Default.ini
[ -f $PFP ] && exit 0
mkdir -p $(dirname $PFP)
cat >$PFP <<EOF
[core]
s0_active_plugins = core;composite;opengl;compiztoolbox;imgjpeg;maximumize;decor;grid;imgsvg;move;place;put;regex;resize;shift;wobbly;annotate;cube;expo;rotate;switcher;td;

[composite]
s0_refresh_rate = 50

[cube]
s0_skydome_image = /usr/share/wallpapers/default.jpg
s0_top_color = #000000ff
s0_bottom_color = #000000ff

[decor]
s0_active_shadow_radius = 0,100000
s0_active_shadow_x_offset = 0
s0_active_shadow_y_offset = -3
s0_inactive_shadow_radius = 0,100000
s0_inactive_shadow_x_offset = 0
s0_inactive_shadow_y_offset = 0
s0_mipmap = true
s0_active_shadow_opacity = 0,010000
s0_inactive_shadow_opacity = 0,010000

EOF

PFP=/etc/skel/.config/compiz-1/compizconfig/config
cat >$PFP <<EOF
[general]
profile =
integration = true
EOF

touch /etc/skel/.config/compiz-1/compizconfig/done_upgrades

exit 0
