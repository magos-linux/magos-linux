#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Подключает и настраивает источники
# Дата модификации: 02.12.2012
# Авторы: Горошкин Антон, Логинов Алексей

if [ "`id -u`" != "0" ] ;then
   echo "Нужны права root"
   exit 1
fi

if [ -f config ] ;then
  . config
else
  echo "Не вижу файла config" ;  exit 1
fi

#rm -rf $MOD_PREV

mkdir -p $MOD_PREV

#urpmi.addmedia --distrib --urpmi-root $MOD_PREV $DIST_MIRROR_0
#urpmi.addmedia --distrib --urpmi-root $MOD_PREV $DIST_MIRROR_1
#urpmi.addmedia --distrib --urpmi-root $MOD_PREV $DIST_MIRROR_2
  
if [ -f urpmi.cfg ]
then
  mkdir -p $MOD_PREV/etc/urpmi
  cp -f urpmi.cfg $MOD_PREV/etc/urpmi/
  urpmi.update -a --urpmi-root $MOD_PREV
fi
