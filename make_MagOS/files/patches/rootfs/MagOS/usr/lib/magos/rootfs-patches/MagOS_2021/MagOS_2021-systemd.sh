#!/bin/bash
#BUGFIX failed state when several conditions
sed -i /ConditionKernelCommandLine=!nosplash/d /lib/systemd/system/plymouth-start.service
sed -i /ConditionKernelCommandLine=!nosplash/d /lib/systemd/system/systemd-ask-password-plymouth.service

exit 0
