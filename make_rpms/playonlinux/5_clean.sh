#!/bin/bash
rmdir ftp
rm -fr rpmbuild rpms srpms
[ -h ~/rpmbuild -a ! -d ~/rpmbuild ] && rm -f ~/rpmbuild