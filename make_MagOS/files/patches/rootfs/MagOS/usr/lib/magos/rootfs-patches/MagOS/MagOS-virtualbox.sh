#!/bin/bash

[ -f /etc/X11/xinit.d/98vboxadd-xclient ] && sed -i s/^[[:space:]]*notify-send/"   true; # notify-send"/ /etc/X11/xinit.d/98vboxadd-xclient

exit 0
