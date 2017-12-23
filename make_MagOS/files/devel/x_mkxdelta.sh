#!/bin/bash
# License: GPL last version . Лицензия : GPL последней версии
# Written: Mikhail Zaripov . Написано: Михаил Зарипов
# Last modified: ___  . Исправлено _____

if [ "`id -u`" != "0" ] ;then
   echo "Для доступа ко всем файлам work/ нужны права root"
   exit 1
fi

NFILE=$(find flash -type f | grep .tar.gz$ | sort -n | tail -1)
OFILE=$(find flash -type f | grep .tar.gz$ | sort -n | tail -2 | head -1)
[ -z "$NFILE" -o -z "$OFILE" ] && exit 1
echo Making patch $OFILE.upd from $OFILE and $NFILE
echo xdelta3 -e -D -s $OFILE $NFILE $OFILE.upd
xdelta3 -e -D -s $OFILE $NFILE $OFILE.upd

