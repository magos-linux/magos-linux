#!/bin/sh
[ -f /usr/bin/nxserver ] || exit 0
chown -R nx:root /etc/nxserver
chown -R nx:root /var/lib/nxserver
passwd -uf nx >/dev/null 2>&1
date +%N | md5sum | cut -c 1-16  > nx.pass
passwd -f --stdin nx <nx.pass >/dev/null 2>&1
rm -f nx.pass

PFP=/usr/bin/nxloadconfig
#BUGFIX fix sed error at every nxserver command
sed -i 's%/dev/null | grep -E .NXAGENT - Version%/dev/null | grep -m1 -E '\''NXAGENT - Version%' $PFP
#fix variables in /usr/bin/nxloadconfig
sed -i 's|^DEFAULT_X_SESSION=.*|DEFAULT_X_SESSION=/etc/X11/Xsession|' $PFP
sed -i 's|CUPS_BACKEND/nxipp|CUPS_BACKEND/ipp|' $PFP
[ -x /usr/bin/startplasma ]     && sed -i 's|^COMMAND_START_KDE=.*|COMMAND_START_KDE=startplasma|'     $PFP
[ -x /usr/bin/startplasma-x11 ] && sed -i 's|^COMMAND_START_KDE=.*|COMMAND_START_KDE=startplasma-x11|' $PFP
sed -i 's|^COMMAND_SMBMOUNT=.*|COMMAND_SMBMOUNT=\"mount -t smbfs\"|' $PFP
sed -i 's|^COMMAND_SMBUMOUNT=.*|COMMAND_SMBUMOUNT=umount|'           $PFP
sed -i 's|\[0123\][.]0|[012345].|g' $PFP
[ -d /usr/lib64 ] && sed -i 's|NX_DIR/lib$|NX_DIR/lib64|' $PFP
sed -i 's|LIBRARY_PATH/libX11.so.6|LIBRARY_PATH/nx/libX11.so.6|' $PFP
# fix for nxagent libs 3.5.99 only
strings /usr/bin/nxagent | grep -q 'NXAGENT - Version 3.5.99' && sed -i 's|libXcompext.so.3|libXcompshad.so.3|' $PFP
#fix no mutual signature supported in nxsetup --test
grep -q ^PubkeyAcceptedKeyTypes= /etc/ssh/ssh_config || echo "PubkeyAcceptedKeyTypes=+ssh-dss" >> /etc/ssh/ssh_config
PFP=/usr/bin/nxagent
#add version for bash nxagent 3.5.0
! strings $PFP | grep -q 'NXAGENT - Version ' && strings $PFP | head -1 | grep -q /bin/bash && echo '#'"$(strings /usr/lib64/nx/bin/nxagent |grep -m1 'NXAGENT - Version')'" >> $PFP
#BUGFIX fix dead link
ln -sf ../fonts /usr/share/nx/fonts

exit 0
#BUGFIX
#grep -q 'COMMAND_NETCAT 2>/dev/null' /usr/bin/nxserver || sed -i 's|COMMAND_NETCAT|COMMAND_NETCAT 2>/dev/null|' /usr/bin/nxserver
#LXDE & GNOME FAILURE BUGFIX
#PFP=etc/nxserver/node.conf
#sed -i s/.*AGENT_EXTRA_OPTIONS_X=.*/'AGENT_EXTRA_OPTIONS_X="-norender"'/ $PFP


#проверяем поэтапно запуская под пользователем
ssh1 сеанс на сервере                   клиент                          ssh2 сеанс на сервере
--------------------------------------  ----------------------------    ----------------------------------------------
nxproxy -C :3000                        nxproxy -S magos-server:3000    DISPLAY=:3000 xterm (будет в своем окне)
nxagent :3000                           (окно само откроется)           DISPLAY=:3000 xterm (будет внутри чёрного окна)
nxagent -display nx/nx,link=modem:3000  nxproxy -S magos-server:3000    DISPLAY=:0 (будет внутри чёрного окна)
nxnode --agent :3000                    (окно само откроется)           DISPLAY=:3000 xterm (будет внутри чёрного окна)
# если nxagent не работает, пробуем варианты LD_LIBRARY_PRELOAD=/usr/lib64/nx/libX11.so.6  LD_LIBRARY_PATH=/usr/lib64/nx nxagent :3000
cd ~/.nx/C-MagOS-Server-20*
nxagent -option options                 (окно само откроется)           DISPLAY=:0 xterm (будет внутри чёрного окна)
