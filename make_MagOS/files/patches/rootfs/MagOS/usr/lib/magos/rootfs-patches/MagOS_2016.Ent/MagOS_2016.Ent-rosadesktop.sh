#!/bin/bash

function hidemenuentry
{
 if [ -f /usr/share/applications/$1.desktop ] ;then
    if ! grep -q "^NotShowIn=MATE" /usr/share/applications/$1.desktop ;then
       if grep -q "^NotShowIn=" /usr/share/applications/$1.desktop ;then
         sed -i s/^NotShowIn=/"NotShowIn=MATE;"/ /usr/share/applications/$1.desktop
       else
         sed -i s/^Exec=/"NotShowIn=MATE\nExec="/ /usr/share/applications/$1.desktop
       fi
    fi
 fi
}

SYSCONF=/etc/sysconfig
[ -d $SYSCONF ] || SYSCONF=/etc/MagOS
ln -sf /lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service
echo -e "DESKTOP=MATE\nDISPLAYMANAGER=lightdm" > $SYSCONF/desktop
sed -i s/Theme=MagOS/Theme=Rosa-EE/ /etc/plymouth/plymouthd.conf
rm -f /usr/share/plymouth/themes/default.plymouth
ln -sf Rosa-EE /usr/share/plymouth/themes/default.plymouth

PFP=/usr/share/xsessions/mate.desktop
sed -i /"^\[ru\]"/d $PFP
sed -i s/"^Comment="/"Name[ru]=Рабочая станция\nComment="/ $PFP
sed -i s/"^Exec="/"Comment[ru]=Рабочая станция с доступом к документам и программам\nExec="/ $PFP
PFP=/usr/share/xsessions/i3term.desktop
cp -p /usr/share/xsessions/i3.desktop $PFP
sed -i s/=i3$/=i3term/ $PFP
sed -i /"^\[ru\]"/d $PFP
sed -i s/"^Comment="/"Name[ru]=Терминал\nComment="/ $PFP
sed -i s/"^Exec="/"Comment[ru]=Ограниченный доступ пользователя только к удалённому терминалу\nExec="/ $PFP

rm -f /etc/skel/.remmina/1289458408692.remmina /usr/share/xsessions/i3.desktop /usr/share/xsessions/i3-with-shmlog.desktop /usr/share/applications/QMPlay2_enqueue.desktop  2>/dev/null

for a in pavucontrol rxvt-unicode scim-setup ;do
  hidemenuentry $a
done

sed -i s/^disable_tray_icon=.*/disable_tray_icon=true/ /etc/skel/.remmina/remmina.pref

echo -e "HOSTNAME=rosa\nPLACEONDESKTOP=chromium-browser,cptools64,firefox,myoffice-presentation,myoffice-spreadsheet,myoffice-text,myteamdesktop,org.remmina.Remmina,rosa-thunderbird,trueconf,ViPNet,sputnik-browser" >> /usr/lib/magos/os-config

FILE=/etc/os-release
cat >$FILE <<EOF
NAME="ROSA Enterprise Linux Desktop"
VERSION="7.3"
ID=rosa
VERSION_ID=7
PRETTY_NAME="RELD 7.3"
ANSI_COLOR="1;34"
HOME_URL="https://www.rosalinux.ru/"
BUG_REPORT_URL="https://bugzilla.rosalinux.ru/"
EOF

FILE=/etc/oem
cat >$FILE <<EOF
SYSTEM="ROSA Enterprise Linux Desktop"
PRODUCT=7.3
EOF

ln -sf user.png /usr/share/faces/default.png

cat >/etc/xdg/user-dirs.defaults  <<EOF
# Default settings for user directories
#
# The values are relative pathnames from the home directory and
# will be translated on a per-path-element basis into the users locale
DESKTOP=Desktop
DOWNLOAD=Downloads
DOCUMENTS=Documents
MUSIC=Documents/Music
PICTURES=Documents/Pictures
VIDEOS=Documents/Videos
TEMPLATES=Documents/Templates
#PUBLICSHARE=Public
EOF

echo "ROSA Enterprise Linux Desktop release 7.3" > /etc/redhat-release

sed -i s/.*NAutoVTs=.*/NAutoVTs=0/   /etc/systemd/logind.conf
sed -i s/.*ReserveVT=.*/ReserveVT=0/ /etc/systemd/logind.conf

sed -i s/^[[:space:]]*notify-send/"   true; # notify-send"/ /etc/X11/xinit.d/98vboxadd-xclient

cat <<EOF >/etc/skel/.remmina/server-voshod_11-0-0-2.remmina
[remmina]
sound=off
sharefolder=
resolution_mode=1
serialdriver=
cert_ignore=0
console=0
name=Сервер Восход
serialname=
exec=
clientname=
shareserial=0
shareparallel=0
printer_overrides=
loadbalanceinfo=
server=11.0.0.2
enable-autostart=0
old-license=0
ssh_tunnel_enabled=0
postcommand=
resolution_height=0
group=
sharesmartcard=0
disable_fastpath=0
serialpath=
username=v.voskhodov
quality=0
microphone=0
colordepth=66
ssh_tunnel_loopback=0
ssh_tunnel_passphrase=
disablepasswordstoring=0
gateway_server=
gateway_password=
resolution_width=0
relax-order-checks=0
ssh_tunnel_password=
ssh_tunnel_username=
serialpermissive=0
smartcardname=
ssh_tunnel_privatekey=
security=
password=
execpath=
gateway_usage=0
disableautoreconnect=0
ssh_tunnel_auth=2
precommand=
parallelname=
ssh_tunnel_server=
domain=voskhod
glyph-cache=0
parallelpath=
protocol=RDP
gateway_username=
ignore-tls-errors=1
gateway_domain=
disableclipboard=0
shareprinter=0
useproxyenv=0
gwtransp=http
viewmode=4
EOF

exit 0
