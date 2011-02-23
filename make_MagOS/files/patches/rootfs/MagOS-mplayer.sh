#!/bin/bash
[ -f etc/mplayer/mplayer.conf ] || exit 0
grep -q "qdbus org.freedesktop.ScreenSaver" etc/mplayer/mplayer.conf && exit 0
echo 'heartbeat-cmd="qdbus org.freedesktop.ScreenSaver /ScreenSaver SimulateUserActivity"' >> etc/mplayer/mplayer.conf
exit 0
