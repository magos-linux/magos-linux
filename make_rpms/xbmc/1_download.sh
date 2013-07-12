#!/bin/bash
URL=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/SRPMS/contrib/updates/xbmc-12.2-1.src.rpm
if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --auto --test --noclean --no-verify-rpm \
           afpclient-devel avahi-common-devel boost-devel bzip2-devel crystalhd-devel cwiid-devel ffmpeg-devel  gettext-devel  jpeg-devel  liblzo2-devel \
           mysql-devel python-devel rtmp-devel ssh-devel tiff-devel tinyxml-devel yajl-devel 'pkgconfig(alsa)' 'pkgconfig(avahi-client)' 'pkgconfig(bluez)' \
           'pkgconfig(enca)' 'pkgconfig(expat)' 'pkgconfig(flac)' 'pkgconfig(fontconfig)' 'pkgconfig(freetype2)' 'pkgconfig(fribidi)' 'pkgconfig(gl)' \
           'pkgconfig(glew)' 'pkgconfig(glu)' 'pkgconfig(ice)' 'pkgconfig(jasper)' 'pkgconfig(libass)' 'pkgconfig(libbluray)' 'pkgconfig(libcdio)' \
           'pkgconfig(libcec)' 'pkgconfig(libcurl)' 'pkgconfig(libmicrohttpd)' 'pkgconfig(libmms)' 'pkgconfig(libmodplug)' 'pkgconfig(libmpeg2)' \
           'pkgconfig(libnfs)' 'pkgconfig(libplist)' 'pkgconfig(libpng)' 'pkgconfig(libpulse)' 'pkgconfig(libshairport)' 'pkgconfig(libva)' \
           'pkgconfig(mad)' 'pkgconfig(ogg)' 'pkgconfig(openssl)' 'pkgconfig(samplerate)' 'pkgconfig(sdl)' 'pkgconfig(SDL_mixer)' 'pkgconfig(SDL_image)' \
           'pkgconfig(smbclient)' 'pkgconfig(taglib)' 'pkgconfig(udev)' 'pkgconfig(vdpau)' 'pkgconfig(vorbis)' 'pkgconfig(wavpack)' 'pkgconfig(x11)' \
           'pkgconfig(xinerama)' 'pkgconfig(xmu)' 'pkgconfig(xrandr)' 'pkgconfig(xt)' 'pkgconfig(xtst)' cmake gperf nasm doxygen swig || exit 1
   mkdir builddeps
   mv /var/cache/urpmi/rpms/*.rpm builddeps
fi
rpm -Uhv builddeps/*.rpm || exit 1
mkdir -p tmp/content rpmbuild/SOURCES rpmbuild/SPECS
curl -# --retry-delay 2 --retry 5 -o tmp/source.src.rpm $URL || exit 1
cd tmp/content
cat ../source.src.rpm | rpm2cpio - | cpio -i || exit 1
cd ../../
mv tmp/content/* rpmbuild/SOURCES || exit 1
mv rpmbuild/SOURCES/*.spec rpmbuild/SPECS || exit 1
rm -fr tmp
