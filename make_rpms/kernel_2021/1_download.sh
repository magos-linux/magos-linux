#!/bin/bash
MARCH=$(awk '{print $1}' /etc/magos-release)
MYPATH=$(dirname $0)
MYPATH=$(readlink -f $MYPATH)
TMPD=/tmp/make_magos_kernel
. ./.config_$MARCH || exit 1
mkdir -p cache/$MARCH/{kernel,builddeps,dkms}

#downloading kernel
rm -fr "$TMPD" &&  mkdir -p "$TMPD"
wget -c $KERNELURL -O "$TMPD/$(basename $KERNELURL)" || exit 1
rsync -r --size-only --delete "$TMPD/" "cache/$MARCH/kernel"

#downloading build deps
rm -fr "$TMPD" &&  mkdir -p "$TMPD/deps"
cd "$TMPD"
rpm2cpio $MYPATH/cache/$MARCH/kernel/kernel-*src.rpm | cpio --quiet -i -d
cd "$MYPATH"
BUILDREQ="$BUILDDEPS "$(grep -i buildrequires: "$TMPD/kernel.spec" | sed s/^.*:[[:space:]]*// | grep -vE "$BUILDEXC" | tr \\n " ")
dnf install --skip-broken -y --downloadonly --destdir "$TMPD/deps" $BUILDREQ
rsync -r --size-only --delete "$TMPD/deps/" "cache/$MARCH/builddeps"

#downloading dkms
rm -fr "$TMPD" &&  mkdir -p "$TMPD/dkms"
dnf install --allowerasing --noautoremove -y --downloadonly --destdir "$TMPD" $(echo $DKMS | tr " " \\n | while read a ;do echo -ne "dkms-$a " ;done)
mv "$TMPD/dkms-"* "$TMPD/kernel-source-"* -t "$TMPD/dkms"
rsync -r --size-only --delete "$TMPD/dkms/" "cache/$MARCH/dkms"

echo Done.

