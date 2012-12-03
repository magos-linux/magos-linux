#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Преобразует название пакетов для базовых модулей
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
mkdir -p $MOD_NAMES_DIR/urpmi/

for MOD in `ls -1 $MOD_NAMES_DIR/??-*` ;do 
    MOD_LINE=$MOD_NAMES_DIR/urpmi/$(basename $MOD)

    cat $MOD | sed -r "s/-$//" >$MOD_LINE
#--------------
done
