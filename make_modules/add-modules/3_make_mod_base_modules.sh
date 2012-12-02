#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Создает XZM для базовых модулей
# Дата модификации: 25.11.2012
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

rm -f $MOD_ROOTFS_DIR/*.$MODULEFORMAT

for MOD in `ls -1 $MOD_NAMES_DIR/??-base$1*` ;do 
    MOD_LINE=$MOD_ROOTFS_DIR/$(basename $MOD)

    echo "Перенос rpms для модуля $(basename $MOD)"
    mv $MOD_LINE/var/cache/urpmi/rpms/* $URPMI_ROOT/var/cache/urpmi/rpms 2>/dev/null
    echo "Создание XZM для модуля $(basename $MOD)"
    mksquashfs $MOD_LINE $MOD_LINE.$MODULEFORMAT $MKSQOPT
#--------------
    echo -ne \\n "---> OK."\\n
done
