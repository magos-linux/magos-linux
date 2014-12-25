#!/bin/bash
#Full cache is Group  Installtid  Name  Nvra  Packagecolor  Providename  Pubkeys  Release  Seqno  Sha1header  Version
#SAVECACHE="Pubkeys"
#mkdir .rpm
#for a in $SAVECACHE ;do
#    cp var/lib/rpm/$a .rpm
#done
chroot ./ /usr/lib/rpm/bin/dbconvert
chroot ./ rpm --import /var/lib/rpm/pubkeys/magos.pubkey
rm -fr var/lib/rpm/__db* var/lib/rpm/pubkeys
#mv .rpm/* var/lib/rpm
#rm -fr .rpm


