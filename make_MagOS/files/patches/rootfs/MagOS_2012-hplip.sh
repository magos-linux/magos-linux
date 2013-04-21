#!/bin/bash
#BUGFIX http://bugs.rosalinux.ru/show_bug.cgi?id=1922
PFP=usr/sbin/hp-setup
rm -f $PFP
cat >$PFP <<EOF
#!/bin/bash
#BUGFIX http://bugs.rosalinux.ru/show_bug.cgi?id=1922
ARG="\$@"
if echo \$ARG | grep -q -- "-i -x -a -q" ;then
    su -c "/usr/share/hplip/setup.py \$ARG" >/dev/null 2>/dev/null
else
    /usr/share/hplip/setup.py \$ARG
fi
EOF
chmod 755 $PFP
