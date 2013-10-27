#!/bin/bash
. .config
mkdir -p rpms/dkms
mv rpms/*-kernel-*.rpm rpms/dkms 2>/dev/null
for a in rpms/dkms/* ;do
    echo $a
    rpm -ihv --nodeps $a || exit 1
done
depmod -a $KERN
echo Done.
