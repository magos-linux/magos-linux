#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Накладывает патчи
# Дата модификации: 21.11.2012
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
cd "$MYPATH"/work/$FLASHNAME-$VERREL/11-base-kernel/boot
ln -sf $(ls -1 vmlinuz-*-* | sed 's|.*/||' | tail -1) vmlinuz || exit 1

echo "Патчи rootfs"
cd "$MYPATH"
rm -fr work/$FLASHNAME-$VERREL/10-base-core/etc/skel/tmp
cp -pfR files/patches/rootfs/rootfs/* work/$FLASHNAME-$VERREL/10-base-core/

echo "Патчи, которые не вошли в апстрим"
cd "$MYPATH"/noupstream_patches
if [ -f mkinitrd ]
then
  mkdir -p "$MYPATH"/work/$FLASHNAME-$VERREL/10-base-core/usr/lib/magos/scripts
  cp -f mkinitrd "$MYPATH"/work/$FLASHNAME-$VERREL/10-base-core/usr/lib/magos/scripts/
fi
