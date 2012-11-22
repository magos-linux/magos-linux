#!/bin/bash
sed -i 's|ExecStart=.*|ExecStart=/sbin/hwclock --localtime --hctosys|' lib/systemd/system/hwclock-load.service
sed -i 's|RUN+=.*|RUN+="/sbin/hwclock --hctosys --localtime --rtc=/dev/%k"|' lib/udev/rules.d/88-clock.rules
