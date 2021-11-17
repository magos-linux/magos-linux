#!/bin/bash
#BUGFIX qcaltool locale
[ -d '/usr/@DATADIRNAME@/locale' ] || exit 0
cp -prf '/usr/@DATADIRNAME@/locale/'* /usr/share/locale/
rm -fr '/usr/@DATADIRNAME@/locale'
rmdir '/usr/@DATADIRNAME@'

exit 0
