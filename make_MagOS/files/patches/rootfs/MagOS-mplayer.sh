#!/bin/bash
PFP=etc/mplayer/mplayer.conf
sed -i s/'ao=pulse,alsa,oss,'/'ao=alsa,oss,pulse,'/ $PFP
sed -i s/'.slang = en'/'slang = ru'/ $PFP
sed -i s/'.alang = en'/'alang = ru'/ $PFP
grep -q "qdbus org.freedesktop.ScreenSaver" $PFP || echo 'heartbeat-cmd="qdbus org.freedesktop.ScreenSaver /ScreenSaver SimulateUserActivity"' >> $PFP
exit 0
