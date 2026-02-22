#!/bin/bash
#BUGFIX failed state when several conditions
sed -i /ConditionKernelCommandLine=!nosplash/d /usr/lib/systemd/system/plymouth-start.service
sed -i /ConditionVirtualization=!container/d   /usr/lib/systemd/system/plymouth-start.service
sed -i /ConditionKernelCommandLine=!nosplash/d /usr/lib/systemd/system/systemd-ask-password-plymouth.service
sed -i /ConditionVirtualization=!container/d   /usr/lib/systemd/system/systemd-ask-password-plymouth.service
[ -f /usr/lib/systemd/system/gpm.service   ] && sed -i 's/^PIDFile=/#PIDFile=/' /usr/lib/systemd/system/gpm.service
[ -f /usr/lib/systemd/system/nginx.service ] && sed -i 's/^PIDFile=/#PIDFile=/' /usr/lib/systemd/system/nginx.service
exit 0
