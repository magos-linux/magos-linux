#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Создает XZM для базовых модулей
# Дата модификации: 29.11.2012
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

rm -f $MOD_ROOTFS_DIR/*patch*.$MODULEFORMAT

MOD_LINE=noupstream_patches/rootfs
echo "Создание XZM для модуля 50-patch-magos"
mksquashfs $MOD_LINE $MOD_ROOTFS_DIR/50-patch-magos.$MODULEFORMAT $MKSQOPT
echo -ne \\n "---> OK."\\n

umount $MOD_PREV/var/cache/urpmi/rpms

MOD_LINE=$MOD_PREV
echo "Создание XZM для модуля 00-patch-urpmi"
mksquashfs $MOD_LINE $MOD_ROOTFS_DIR/00-patch-urpmi.$MODULEFORMAT $MKSQOPT
echo -ne \\n "---> OK."\\n

DISTRVERSION=$(date +%Y%m%d)
DESTDIR=flash/${FLASHNAME}_${VERREL}_${DISTRVERSION}

if [ -d "$MYPATH/$DESTDIR/$FLASHNAME/base" ]
then
    echo "Перемещение модулей"
    cd "$MYPATH/work/$FLASHNAME-$VERREL" || exit 1
    mv -f *.$MODULEFORMAT $MYPATH/$DESTDIR/$FLASHNAME/base/
    cd "$MYPATH/$DESTDIR/$FLASHNAME/base"
    chmod 444 *
    md5sum *.$MODULEFORMAT >MD5SUM
fi

echo "Работа скрипта завершена"
exit 0
