#!/bin/bash
#BUGFIX failed state when several conditions
sed -i /ConditionKernelCommandLine=!nosplash/d /usr/lib/systemd/system/plymouth-start.service
sed -i /ConditionVirtualization=!container/d   /usr/lib/systemd/system/plymouth-start.service
sed -i /ConditionKernelCommandLine=!nosplash/d /usr/lib/systemd/system/systemd-ask-password-plymouth.service
sed -i /ConditionVirtualization=!container/d   /usr/lib/systemd/system/systemd-ask-password-plymouth.service
for a in /usr/lib/systemd/system/*.service ;do
  sed -i 's/^PIDFile=/#PIDFile=/' "$a"
done
exit 0
