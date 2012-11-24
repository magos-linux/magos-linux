#!/bin/bash
PFP=etc/krb5.conf
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
