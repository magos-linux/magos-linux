#!/bin/sh
[ -f usr/bin/nxserver ] || exit 0
cat >etc/nxserver/users.id_dsa <<EOF
-----BEGIN DSA PRIVATE KEY-----
MIIBvAIBAAKBgQDKabJeo9q/bB+iGilUjDCvAbo1wJNKROqII/uYPAmRQ+Wi6MDW
ric+NHgtb5ql3WNuh7VfaiO4YJx6Hwz4tDQ7TLthDii0/gFTS/9pypdkdndVYyhH
oXdvaBnbIEvOxD7IbP3H+sscniDymSbfB8Lw3lBxyi4tHX+XepYeVbYcoQIVANis
PpC+BiaQ2zqhFPanW8Nv2sOLAoGBAI+kchDYaHINtLPORszbSjOXL/TVzmZBd+Lj
+WljU93VOc2a4MFgqhF8Wch+rx3sg0bsaWcRQ2IPRsxoi6vkGhK/i7gFH4/iFsrV
TJhYM8MZya7Jvtg68LwgT1+SCr++B3nboRNMTtYICZF/92hC1N0T4heRm9WW51CD
inUD29pXAoGBAL3wnO229atDDKNDb7wqFUkvdQTuuGdZzNhDvekHaePG89hI5ZRY
GEG+0FXDqFo1yy3LVk4kDx/sHtHVokpC4VYR/UdwvggFybCiXnq/t6aCVgCkEFQq
4STi1a1a4loXk2dAw4p+PpPoetl0msBk2pMWnz1BSnLEb+YNKmDIMxtjAhRHuu1U
uSS8yUnFkDMHkGm9Vngm4A==
-----END DSA PRIVATE KEY-----
EOF
cat >etc/nxserver/users.id_dsa.pub <<EOF
ssh-dss AAAAB3NzaC1kc3MAAACBAMppsl6j2r9sH6IaKVSMMK8BujXAk0pE6ogj+5g8CZFD5aLowNauJz40eC1vmqXdY26HtV9qI7hgnHofDPi0NDtMu2EOKLT+AVNL/2nKl2R2d1VjKEehd29oGdsgS87EPshs/cf6yxyeIPKZJt8HwvDeUHHKLi0df5d6lh5VthyhAAAAFQDYrD6QvgYmkNs6oRT2p1vDb9rDiwAAAIEAj6RyENhocg20s85GzNtKM5cv9NXOZkF34uP5aWNT3dU5zZrgwWCqEXxZyH6vHeyDRuxpZxFDYg9GzGiLq+QaEr+LuAUfj+IWytVMmFgzwxnJrsm+2DrwvCBPX5IKv74HeduhE0xO1ggJkX/3aELU3RPiF5Gb1ZbnUIOKdQPb2lcAAACBAL3wnO229atDDKNDb7wqFUkvdQTuuGdZzNhDvekHaePG89hI5ZRYGEG+0FXDqFo1yy3LVk4kDx/sHtHVokpC4VYR/UdwvggFybCiXnq/t6aCVgCkEFQq4STi1a1a4loXk2dAw4p+PpPoetl0msBk2pMWnz1BSnLEb+YNKmDIMxtj root@MagOS-Server
EOF
chroot ./ /bin/chown -R nx.root /etc/nxserver
chroot ./ /bin/chown -R nx.root /var/lib/nxserver
chroot ./ /usr/bin/passwd -uf nx >/dev/null 2>&1
[ "$(pwd)" = "/" ] || mount -o bind /dev dev
date +%N | md5sum | cut -c 1-16  > nx.pass
chroot ./  /usr/bin/passwd -f --stdin nx <nx.pass >/dev/null 2>&1
[ "$(pwd)" = "/" ] || umount dev
rm -f nx.pass
#BUGFIX
grep -q 'COMMAND_NETCAT 2>/dev/null' usr/bin/nxserver || sed -i 's|COMMAND_NETCAT|COMMAND_NETCAT 2>/dev/null|' usr/bin/nxserver
#LXDE & GNOME FAILURE BUGFIX
PFP=etc/nxserver/node.conf
#sed -i s/.*AGENT_EXTRA_OPTIONS_X=.*/'AGENT_EXTRA_OPTIONS_X="-norender"'/ $PFP
exit 0
