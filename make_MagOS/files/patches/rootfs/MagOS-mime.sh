#!/bin/bash
[ -f usr/bin/update-mime-database ] || exit 0
DMF=usr/share/applications/defaults.list
function update_mime
{
  [ "$2" = "" ] && return 1
  grep -q "$1=$2" $DMF && return 0
  grep -q "$1=" $DMF || echo "$1=" >> $DMF
  sed -i s%"$1="%"$1=$2;"% $DMF
  echo "$1=$2;" >> etc/skel/.local/share/applications/defaults.list
  echo "$1=$2;" >> etc/skel/.local/share/applications/mimeapps.list
}

sed -i /'inode\/directory='/d usr/share/applications/mimeapps.list
mkdir -p etc/skel/.local/share/applications 2>/dev/null
echo '[Default Applications]' > etc/skel/.local/share/applications/defaults.list
echo '[Added Associations]' > etc/skel/.local/share/applications/mimeapps.list
update_mime application/x-visio libreoffice-draw.desktop
update_mime application/x-mimearchive firefox.desktop
update_mime application/x-lzm gactivate.desktop
update_mime application/pdf pdfview.desktop
update_mime application/x-ms-dos-executable wine.desktop
update_mime application/x-fictionbook FBReader.desktop
update_mime application/x-cd-image isomaster.desktop
update_mime application/x-rpm mandriva-gurpmi.desktop
update_mime image/jpeg gpicview.desktop
update_mime image/png gpicview.desktop
update_mime image/jpg gpicview.desktop
update_mime image/tiff kde4-okularApplication_tiff.desktop
update_mime video/mpeg mplayer.desktop
update_mime video/x-msvideo mplayer.desktop
update_mime video/ogg mplayer.desktop
update_mime video/dv mplayer.desktop
update_mime video/mp4 mplayer.desktop
update_mime video/msvideo mplayer.desktop
update_mime video/quicktime mplayer.desktop
update_mime video/x-anim mplayer.desktop
update_mime video/x-avi mplayer.desktop
update_mime video/x-flc mplayer.desktop
update_mime video/x-fli mplayer.desktop
update_mime video/x-mpeg mplayer.desktop
update_mime video/x-ms-asf mplayer.desktop
update_mime video/x-msvideo mplayer.desktop
update_mime video/x-msv mplayer.desktop
update_mime video/x-ms-wmv mplayer.desktop
update_mime video/x-nsv mplayer.desktop
update_mime audio/mpeg qmmp.desktop
update_mime audio/mpegurl qmmp.desktop
update_mime audio/x-flac qmmp.desktop
update_mime audio/x-m4a qmmp.desktop
update_mime audio/x-mp3-playlist qmmp.desktop
update_mime audio/x-mp3 qmmp.desktop
update_mime audio/x-mpeg qmmp.desktop
update_mime audio/x-mpegurl qmmp.desktop
update_mime audio/x-ms-asf qmmp.desktop
update_mime audio/x-ms-asx qmmp.desktop
update_mime audio/x-ms-wax qmmp.desktop
update_mime audio/x-pn-aiff qmmp.desktop
update_mime audio/x-pn-au qmmp.desktop
update_mime audio/x-pn-wav qmmp.desktop
update_mime audio/x-pn-windows-acm qmmp.desktop
update_mime audio/x-real-audio qmmp.desktop
update_mime audio/x-scpls qmmp.desktop
update_mime audio/ogg qmmp.desktop
update_mime audio/x-wav qmmp.desktop

update_mime x-content/video-dvd mplayer-play-disk.desktop
update_mime x-content/video-vcd mplayer-play-disk.desktop
update_mime x-content/video-svcd mplayer-play-disk.desktop
update_mime x-content/video-blueray mplayer-play-disk.desktop
update_mime x-content/video-hddvd mplayer-play-disk.desktop
update_mime x-content/video-dvd gnome-mplayer-play-disk.desktop
update_mime x-content/video-vcd gnome-mplayer-play-disk.desktop
update_mime x-content/video-svcd gnome-mplayer-play-disk.desktop
update_mime x-content/video-blueray gnome-mplayer-play-disk.desktop
update_mime x-content/video-hddvd gnome-mplayer-play-disk.desktop
update_mime x-content/audio-cdda grip.desktop
update_mime x-content/audio-dvd grip.desktop
update_mime x-content/audio-cdda qmmp-play-cd.desktop
update_mime x-content/audio-dvd qmmp-play-cd.desktop
update_mime x-content/audio-player qmmp.desktop

chroot ./ update-mime-database /usr/share/mime

exit 0
