#!/bin/bash
# https://fstec.ru/dokumenty/vse-dokumenty/spetsialnye-normativnye-dokumenty/metodicheskij-dokument-ot-25-dekabrya-2022-g?ysclid=lqgv20mj8y600935230

chmod go-rwx /etc/shadow
chmod -R go-rwx /etc/skel

grep -q "^UMASK" /etc/login.defs || echo "UMASK           077" >> /etc/login.defs
grep -q "^UMASK[[:space:]]*077" /etc/login.defs || sed -i s/^UMASK.*/"UMASK           077"/ /etc/login.defs

grep -q "^auth[[:space:]]*required[[:space:]]*pam_wheel.so[[:space:]]*use_uid" /etc/pam.d/su || echo "auth       required     pam_wheel.so use_uid" >> /etc/pam.d/su

grep -qi ^PermitRootLogin  /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config

[ -f /etc/sysctl.d/99-fstec_security.conf ] || cat >/etc/sysctl.d/99-fstec_security.conf <<EOF
# allow access to dmesg only for root
kernel.dmesg_restrict=1
# disable loading another kernel
kernel.kexec_load_disabled=1
# randomized address and data space
kernel.randomize_va_space=2
# disable userfaultfd system calls for unprivileged users
vm.unprivileged_userfaultfd=0
# protection against 'kernel NULL pointer dereference'
vm.mmap_min_addr=4096
# disallow autoload modules for terminal line discipline (LDISC)
dev.tty.ldisc_autoload=0
# restrictions for symlinks from TOCTOU atacks
fs.protected_symlinks=1
# restrict create hardlink to unaccessible files
fs.protected_hardlinks=1
# disallow FIFO in world-writable folders
fs.protected_fifos=2
# protect world-writable sticky files from TOCTOU atacks
fs.protected_regular=2
# disable dumps for suid files
fs.suid_dumpable=0
# disallows access to perf features (raw tracepoint access, CPU event access, and kernel profiling)
kernel.perf_event_paranoid=3
# debug disable (perf, BPF)
kernel.kptr_restrict=2
# disable eBPF in userspace
kernel.unprivileged_bpf_disabled=1
# enable eBPF JIT protection
net.core.bpf_jit_harden=2
# disable ptrace (conflict with game injectors, such as UEVR)
kernel.yama.ptrace_scope=3
#conflicts with portproton
#user.max_user_namespaces=0
EOF

exit 0
