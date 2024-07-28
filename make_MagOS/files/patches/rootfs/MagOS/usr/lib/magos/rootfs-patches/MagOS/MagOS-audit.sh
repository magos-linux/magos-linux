#!/bin/bash

[ -x /sbin/auditd ] || exit 0

PFP=/etc/audit/rules.d/audit.rules
grep -q MagOS "$PFP" 2>/dev/null || cat >"$PFP" <<EOF
#MagOS audit rules

-w /var/log -p w -k var_log_changes

-w /etc/group -p wa -k etcgroup
-w /etc/gshadow -k etcgroup

-w /etc/passwd -p wa -k etcpasswd
-w /etc/shadow -k etcpasswd
-w /etc/security/opasswd -k opasswd
-w /etc/adduser.conf -k adduserconf

-w /etc/sudoers -p wa -k sudoers

-w /bin/systemctl -p x -k actions

-w /usr/bin/passwd -p x -k passwd_modification
-w /usr/bin/gpasswd -p x -k gpasswd_modification

-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification
-w /usr/sbin/addgroup -p x -k group_modification

-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/adduser -p x -k user_modification

-w /etc/logins.defs -p wa -k login
-w /etc/securetty -p wa -k login
-w /var/log/faillog -p wa -k login
-w /var/log/lastlog -p wa -k login
-w /var/log/tallylog -p wa -k login

-a exit,always -F path=/usr/bin/sudo -F perm=x -k user_execution
-a exit,always -F path=/bin/su       -F perm=x -k user_execution

-a exit,always -F arch=b64 -S execve -F uid=0 -k authentication_events
-a exit,always -F arch=b32 -S execve -F uid=0 -k authentication_events

-a exit,always -F arch=b64 -S bind -S connect -F success=0 -k network_events

-w /dev/bus/usb -p rwxa -k usb
EOF

exit 0
