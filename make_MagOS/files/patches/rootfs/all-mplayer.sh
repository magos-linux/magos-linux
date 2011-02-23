#!/bin/bash
[ -f etc/mplayer/mplayer.conf ] || exit 0
sed -i s/'ao=pulse,alsa,oss,'/'ao=alsa,oss,pulse,'/ etc/mplayer/mplayer.conf
sed -i s/'.slang = en'/'slang = ru'/ etc/mplayer/mplayer.conf
sed -i s/'.alang = en'/'alang = ru'/ etc/mplayer/mplayer.conf
exit 0
