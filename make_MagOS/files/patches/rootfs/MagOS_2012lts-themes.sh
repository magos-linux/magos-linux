#!/bin/bash

sed -i s/^msg_color.*$/'msg_color               #000000'/ usr/share/slim/themes/default/slim.theme

PFP=etc/xdg/lxsession/LXDE/desktop.conf
sed -i s%sNet/ThemeName=.*%sNet/ThemeName=elementary% $PFP
sed -i s%sNet/IconThemeName=.*%sNet/IconThemeName=elementary% $PFP
sed -i s%sGtk/CursorThemeName=.*%sGtk/CursorThemeName=elementary% $PFP

exit 0
