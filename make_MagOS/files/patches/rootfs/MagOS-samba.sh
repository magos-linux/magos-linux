#!/bin/bash
PFP=etc/samba/smb.conf
[ -f $PFP ] || exit 0
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config
[global]
  workgroup = MDKGROUP
  server string = %h
  security = user
  preferred master = no
  interfaces = eth0 lo
  bind interfaces only = Yes
  hosts allow = 127.0.0.1 192.168.1. EXCEPT 192.168.1.1
  hosts deny = ALL
  username map = /etc/samba/smbusers
#  passdb backend = tdbsam:/etc/samba/passdb.tdb
  encrypt passwords = yes
  guest account = nobody
  dns proxy = no
  os level = 20
#  null passwords = no
  hide unreadable = yes
  hide dot files = yes
  invalid users = root admin @wheel
  client ldap sasl wrapping = sign
  pam password change = yes
#  allow trusted domains = no
  winbind enum users = yes
  winbind enum groups = yes
  winbind use default domain = yes
  winbind nested groups = yes
#  winbind separator = +
  idmap uid = 10000-20000
  idmap gid = 10000-20000
  template shell = /bin/bash
  template homedir = /home/%U
  printcap name = cups
  printing = cups
  log level = 3
  log file = /var/log/samba/%m.log
  max log size = 50

[media]
  browseable = yes
  writeable = yes
  path = /media
  comment = media
  valid users = @users
  force group = users
  public = yes
  create mode = 0664
  directory mode = 0775

[public]
  path = /media/public
  comment = public
  guest ok = yes
  guest only = yes
  force group = users
  browseable = yes
  public = yes
  writeable = Yes
  create mode = 0664
  directory mode = 0775

[printers]
  printable = yes
  valid users = @users
  path = /var/spool/samba
EOF
exit 0
