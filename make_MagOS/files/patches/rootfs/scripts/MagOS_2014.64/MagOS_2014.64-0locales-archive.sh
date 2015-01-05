#!/bin/bash
cat ../../../../files/locales-archive | while read a ;do
   chroot . localedef --replace --add-to-archive "/usr/share/locale/$a" 
done
