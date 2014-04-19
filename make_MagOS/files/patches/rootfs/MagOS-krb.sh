#!/bin/bash
#PAM files to switch samba AD and back
cp -pf etc/pam.d/system-auth etc/pam.d/system-auth-default
cat >etc/pam.d/system-auth-krb <<EOF
#%PAM-1.0

auth        required      pam_env.so
auth        sufficient    pam_krb5.so  ccache=/tmp/krb5cc_%u
auth        sufficient    pam_tcb.so shadow nullok prefix=\$2a\$ count=8 use_first_pass
auth        sufficient    pam_winbind.so use_first_pass
auth        required      pam_deny.so

account     required      pam_unix.so
account     sufficient    pam_succeed_if.so uid < 100 quiet
account     sufficient    pam_winbind.so use_first_pass
account     required      pam_permit.so

password    sufficient    pam_krb5.so minimum_uid=10000
password    required      pam_cracklib.so try_first_pass retry=3
password    sufficient    pam_tcb.so use_authtok shadow write_to=shadow nullok prefix=\$2a\$ count=8
password    required      pam_deny.so

session     required      pam_limits.so
session     required      pam_unix.so
session     required      pam_winbind.so debug use_first_pass
session     required      pam_mkhomedir.so skel=/etc/skel umask=0022
EOF


PFP=etc/krb5.conf
[ -f $PFP ] || exit 0
grep -q MAGOS $PFP  && exit 0
cat >$PFP <<EOF
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = LOCAL.MAGOS-LINUX.RU
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = yes

[realms]
 LOCAL.MAGOS-LINUX.RU = {
 kdc = kerberos.local.magos-linux.ru
 admin_server = kerberos.local.magos-linux.ru
 default_domain = local.magos-linux.ru
}

[domain_realm]
 .kerberos.server = LOCAL.MAGOS-LINUX.RU
 slpu.gpp.gazprom.ru = LOCAL.MAGOS-LINUX.RU
 .slpu.gpp.gazprom.ru = LOCAL.MAGOS-LINUX.RU

[kdc]
 profile = /var/kerberos/krb5kdc/kdc.conf

[appdefaults]
 pam = {
   debug = false
   ticket_lifetime = 36000
   renew_lifetime = 36000
   forwardable = true
   krb4_convert = false
 }
EOF

exit 0
