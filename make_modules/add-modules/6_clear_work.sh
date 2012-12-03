#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Очищает сборочную
# Дата модификации: 03.12.2012
# Авторы: Горошкин Антон, Логинов Алексей

if [ "`id -u`" != "0" ] ;then
   echo "Нужны права root"
   exit 1
fi

if [ -f .config ] ;then
  . .config
else
  echo "Не вижу файла .config" ;  exit 1
fi
cd "$MYPATH"


function umountbranches()
{
 while grep -q "$1" /proc/mounts ;do
    grep "$1" /proc/mounts | awk '{print $2}' | while read a ;do
       echo umount "$a"
       umount "$a" 2>/dev/null
    done
 done
}

umountbranches "$ROOTFS"

#rm -rf work

echo "Работа скрипта завершена"
exit 0
