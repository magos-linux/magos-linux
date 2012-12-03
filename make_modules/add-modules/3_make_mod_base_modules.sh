#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Создает XZM для базовых модулей
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

if [ "$SQFSVER" = "3" ] ;then
  MKSQUASHFS=mksquashfs3
  UNSQUASHFS=unsquashfs3
  MODULEFORMAT=lzm
else
  MKSQUASHFS=mksquashfs
  UNSQUASHFS=unsquashfs
  MODULEFORMAT=xzm
fi

mkdir -p $ROOTFS

rm -f $MOD_ROOTFS_DIR/*base*.$MODULEFORMAT

for MOD in `ls -1 $MOD_NAMES_DIR/??-base*` ;do
    MOD_LINE=$MOD_ROOTFS_DIR/$(basename $MOD)
    echo "Перенос rpms для модуля $(basename $MOD) в $MOD_RPMS"
    mv -f $MOD_LINE/var/cache/urpmi/rpms/* $MOD_RPMS/ 2>/dev/null
    echo "Создание XZM для модуля $(basename $MOD)"
    mksquashfs $MOD_LINE $MOD_LINE.$MODULEFORMAT $MKSQOPT
    echo -ne \\n "---> OK."\\n
done

echo "Работа скрипта завершена"
exit 0
