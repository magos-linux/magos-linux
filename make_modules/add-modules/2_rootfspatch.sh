#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Накладывает патчи
# Дата модификации: 29.11.2012
# Авторы: Горошкин Антон, Логинов Алексей

if [ -f config ] ;then
  . config
else
  echo "Не вижу файла config" ;  exit 1
fi
cd "$MYPATH"

if [ "`id -u`" != "0" ] ;then
   echo "Нужны права root"
   exit 1
fi

echo "Создание ссылок на исходники ядра"
cd "$MYPATH"/work/$FLASHNAME-$VERREL/10-base-core/boot
ln -sf $(ls -1 vmlinuz-*-* | sed 's|.*/||' | tail -1) vmlinuz || exit 1

echo "Работа скрипта завершена"
exit 0
