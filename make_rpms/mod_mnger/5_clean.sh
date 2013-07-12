#!/bin/bash
umount ftp
rmdir ftp
rm -fr rpmbuild rpms srpms SOURCES/*.tar.*
[ -h ~/rpmbuild -a ! -d ~/rpmbuild ] && rm -f ~/rpmbuild
echo Done.
