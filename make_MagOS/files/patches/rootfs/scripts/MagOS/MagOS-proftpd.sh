#!/bin/bash
[ -f etc/proftpd.conf ] || exit 0
LDP=usr/lib/proftpd
[ -d $LDP ] || LDP=usr/lib64/proftpd
PFP=etc/proftpd.conf
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config
Include /etc/proftpd.d/*.conf
ModulePath /$LDP
ModuleControlsACLs insmod,rmmod allow user root
ModuleControlsACLs lsmod allow user *

ServerName "FTP Server"
ServerType			standalone
DeferWelcome off

MultilineRFC2228		on
DefaultServer on
ShowSymlinks on

TimeoutNoTransfer		600
TimeoutStalled			600
TimeoutIdle			1200

DisplayLogin                    welcome.msg
ListOptions "-l"
DenyFilter			\*.*/
UseIPv6                         Off

AllowStoreRestart on

Port 21

MaxInstances			30

User				nobody
Group				nogroup

RequireValidShell off
Umask 002 002

DefaultRoot /media

AllowOverwrite			on
PersistentPasswd		off

TransferLog /var/log/proftpd/proftpd.log
SystemLog   /var/log/proftpd/proftpd.log

<IfModule mod_tls.c>
    TLSEngine off
</IfModule>

<IfModule mod_quota.c>
    QuotaEngine on
</IfModule>

<IfModule mod_ratio.c>
    Ratios on
</IfModule>

<IfModule mod_delay.c>
    DelayEngine on
</IfModule>

<IfModule mod_ctrls.c>
    ControlsEngine        on
    ControlsMaxClients    2
    ControlsLog           /var/log/proftpd/controls.log
    ControlsInterval      5
    ControlsSocket        /var/run/proftpd/proftpd.sock
</IfModule>

<IfModule mod_ctrls_admin.c>
    AdminControlsEngine on
</IfModule>

<Limit SITE_CHMOD WRITE READ PWD>
    DenyAll
</Limit>

<Directory /media>
AllowAll
<Limit READ PWD>
    AllowGroup users
</Limit>
</Directory>

<Directory /media/common>
AllowAll
<Limit WRITE>
    AllowAll
</Limit>
</Directory>

<Anonymous /media/public>
User ftp
Group ftp
UserAlias anonymous ftp
CDPath /media/public
RequireValidShell off
MaxClients                    5 "Sorry, max %m users -- try again later"
#UserDirRoot /media/public

<Directory /media/public>
AllowAll
GroupOwner users
Umask 002 002
<Limit WRITE>
    DenyALL
</Limit>
<Limit PWD READ>
    AllowALL
</Limit>
</Directory>

<Directory /media/public/inbox>
AllowAll
GroupOwner users
Umask 002 002
<Limit WRITE>
    AllowALL
</Limit>
</Directory>

</Anonymous>

CDPath /media
EOF
exit 0
