#!/bin/bash
chroot ./ /usr/sbin/alternatives --set gl_conf /etc/ld.so.conf.d/GL/standard.conf
chroot ./ /sbin/ldconfig
