#!/bin/bash
rmdir ftp
rm -fr rpmbuild rpms srpms builddeps
[ -h ~/rpmbuild -a ! -d ~/rpmbuild ] && rm -f ~/rpmbuild
