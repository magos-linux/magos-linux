#!/bin/bash
rm -f usr/lib/locale/locale-archive
for a in en_US ru_RU ;do
   chroot . localedef -c -f UTF-8 -i "$a" $a.UTF-8
done
