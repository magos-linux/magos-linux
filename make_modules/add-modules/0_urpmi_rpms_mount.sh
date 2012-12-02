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

mkdir -p $MOD_RPMS $MOD_PREV/var/cache/urpmi/rpms
mount -o bind $MOD_RPMS $MOD_PREV/var/cache/urpmi/rpms

echo "Работа скрипта завершена"
exit 0
