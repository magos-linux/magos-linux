#!/bin/bash
MARCH=$(awk '{print $1}' /etc/magos-release)
TMPD=/tmp/make_magos_kernel
. ./.config_$MARCH || exit 1
mkdir -p cache/$MARCH/{kernel,builddeps,dkms}

#downloading kernel
rm -fr "$TMPD" &&  mkdir -p "$TMPD"
wget -c $KERNELURL -O "$TMPD/$(basename $KERNELURL)" || exit 1
rsync -r --size-only --delete "$TMPD/" "cache/$MARCH/kernel"

#downloading build deps
urpmi.update -a
rpmdbreset --copy
rm -f /var/cache/urpmi/rpms/*
#urpmi --nofdigests --auto --no-suggests --test --noclean --buildrequires cache/$MARCH/kernel/*.rpm
urpmi --nofdigests --auto --no-suggests --test --noclean $BUILDDEPS
rsync -r --size-only --delete /var/cache/urpmi/rpms/ "cache/$MARCH/builddeps"

#downloading dkms
rm -fr "$TMPD" &&  mkdir -p "$TMPD"
ROSADKMS=
curl -l $MAGOSREP 2>/dev/null | grep ^dkms- | sort  > "$TMPD/magosmedia.txt" || exit 1
for a in $DKMS ;do
  FN=$(grep ^dkms-$a "$TMPD/magosmedia.txt" | tail -1)
  if [ ! -z "$FN" ] ;then
     echo Downloading dkms-$a
     wget -q $MAGOSREP$FN -O "$TMPD/$FN" || exit 1
  else
     ROSADKMS="$ROSADKMS dkms-$a"
  fi
done
if [ ! -z "$ROSADKMS" ] ;then
  echo Downloading "$ROSADKMS"
  rm -f /var/cache/urpmi/rpms/*
  urpmi -q --force --nofdigests --no-download-all  --test --noclean $ROSADKMS
  mv /var/cache/urpmi/rpms/dkms-* "$TMPD"
fi

rm -f "$TMPD/magosmedia.txt"
rsync -r --size-only --delete  "$TMPD/" "cache/$MARCH/dkms"

echo Done.

