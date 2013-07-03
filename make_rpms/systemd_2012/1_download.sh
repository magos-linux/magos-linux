#!/bin/bash
URL=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/SRPMS/main/updates/systemd-194-20.src.rpm
if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --auto --test --noclean --no-verify-rpm libtool acl-devel audit-devel gperf intltool libcap-devel pam-devel tcp_wrappers-devel vala  pciutils-devel python-devel \
          'pkgconfig(dbus-glib-1)' 'pkgconfig(gee-0.8)' 'pkgconfig(gtk+-2.0)' 'pkgconfig(libcryptsetup)' 'pkgconfig(libnotify)' 'pkgconfig(libxslt)' \
          'pkgconfig(blkid)' 'pkgconfig(gobject-introspection-1.0)' || exit 1
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
