#!/bin/bash
PFP=etc/X11/prefdm
grep -q MagOS $PFP && exit 0
cp -pf $PFP $PFP.old
cat >$PFP <<EOF
#!/bin/sh
# waiting network services
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS
if echo "\$DMFASTBOOT" | egrep -qi 'no|off|false' ;then
  while ! [ -f /var/lock/subsys/local ] ;do
    sleep 1s
  done
fi
EOF
sed -i 1d $PFP.old
cat $PFP.old >>$PFP
rm -f $PFP.old
sed -i s='wait $!'='wait $!\n            exit 0'= $PFP
exit 0
