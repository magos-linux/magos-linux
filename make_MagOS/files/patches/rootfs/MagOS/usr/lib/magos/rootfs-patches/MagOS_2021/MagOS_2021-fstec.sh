#!/bin/bash
# https://fstec.ru/dokumenty/vse-dokumenty/spetsialnye-normativnye-dokumenty/metodicheskij-dokument-ot-25-dekabrya-2022-g?ysclid=lqgv20mj8y600935230

chmod go-rwx /etc/shadow
chmod -R go-rwx /etc/skel

grep -q "^UMASK" /etc/login.defs || echo "UMASK           077" >> /etc/login.defs
grep -q "^UMASK[[:space:]]*077" /etc/login.defs || sed -i s/^UMASK.*/"UMASK           077"/ /etc/login.defs

grep -q "^auth[[:space:]]*required[[:space:]]*pam_wheel.so[[:space:]]*use_uid" /etc/pam.d/su || echo "auth       required     pam_wheel.so use_uid" >> /etc/pam.d/su

grep -qi ^PermitRootLogin  /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config

[ -f /etc/sysctl.d/99-fstec_security.conf ] || cat >/etc/sysctl.d/99-fstec_security.conf <<EOF
kernel.dmesg_restrict=1
kernel.kptr_restrict=2
kernel.kexec_load_disabled=1
kernel.perf_event_paranoid=3
kernel.randomize_va_space=2
kernel.unprivileged_bpf_disabled=1
kernel.yama.ptrace_scope=3
net.core.bpf_jit_harden=2
vm.unprivileged_userfaultfd=0
vm.mmap_min_addr=4096
dev.tty.ldisc_autoload=0
fs.protected_symlinks=1
fs.protected_hardlinks=1
fs.protected_fifos=2
fs.protected_regular=2
fs.suid_dumpable=0
#conflicts with portproton
#user.max_user_namespaces=0
EOF

exit 0
