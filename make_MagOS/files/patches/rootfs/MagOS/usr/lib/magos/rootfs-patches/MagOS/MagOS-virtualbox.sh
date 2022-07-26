#!/bin/bash
PFP=/etc/X11/xinit.d/98vboxadd-xclient
[ -f $PFP ] || PFP=/etc/X11/xinit/xinitrc.d/98vboxadd-xclient.sh
[ -f $PFP ] && sed -i s/^[[:space:]]*notify-send/"   true; # notify-send"/ $PFP

exit 0
