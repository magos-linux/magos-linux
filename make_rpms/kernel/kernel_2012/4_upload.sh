#!/bin/bash
FTPS=magos.sibsau.ru
ls rpms | grep -qm1 rosa2012[.]1.*.rpm$ && ARCH=2012
ls rpms | grep -qm1 rosa.lts2012[.]0.*.rpm$ && ARCH=2012lts
ls rpms | grep -qm1 mdv2011[.]0.*.rpm$ && ARCH=2011
echo "Detecting rpm architure ... $ARCH"
[ "$ARCH" = "" ] && exit 1
mkdir -p ftp
echo "Uploading to $FTPS"
[ "$FTPU" = "" ] && read -p "Username:" FTPU
[ "$FTPU" = "" ] && exit 1
echo "Connecting as $FTPU to $FTPS"
curlftpfs -o user=$FTPU $FTPS ftp || exit 1
echo "Transfering rpms to ftp/rpms/$ARCH/ ..."
cp -vf rpms/* ftp/rpms/$ARCH/ || exit 1
echo "Transfering srpms to ftp/rpms/srpms/ ..."
#cp -vf srpms/* ftp/rpms/srpms/ || exit 1
echo Done.
