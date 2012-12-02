#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Создает итоговый дистрибутив
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

DISTRVERSION=$(date +%Y%m%d)
SRCDIR="$MYPATH/work/$FLASHNAME-$VERREL/rootfs"
DESTDIR=flash/${FLASHNAME}_${VERREL}_${DISTRVERSION}
if [ "$SQFSVER" = "3" ] ;then
  MKSQUASHFS=mksquashfs3
  UNSQUASHFS=unsquashfs3
  MODULEFORMAT=lzm
else
  MKSQUASHFS=mksquashfs
  UNSQUASHFS=unsquashfs
  MODULEFORMAT=xzm
fi

echo "Подготовка"
#[ -d "$DESTDIR" ] && rm -fr "$DESTDIR"
mkdir -p "$DESTDIR" || exit 1
mkdir -p "$DESTDIR"/$FLASHNAME/{base,modules,optional,rootcopy}
mkdir -p "$DESTDIR"/$FLASHNAME-Data/{changes,homes,modules,optional,rootcopy}
cp -pR files/patches/flash/* "$DESTDIR"
cp -L "$SRCDIR"/boot/vmlinuz "$DESTDIR"/$FLASHNAME
echo $VERREL $DISTRVERSION  > "$DESTDIR"/$FLASHNAME/VERSION
cd work/$FLASHNAME-$VERREL
echo $VERREL $DISTRVERSION  > VERSION

echo "Патчи rootfs"
cd "$MYPATH"
cp -pfR noupstream_patches/rootfs/* $ROOTFS/

cd work/$FLASHNAME-$VERREL

echo "Cоздание initrd"
mkdir -p rootfs/{tmp,proc,sys,dev,/mnt/live} || exit 1
if [ "$FS_ROOTFS" = "aufs" ]
then
  mount -o bind /dev rootfs/dev || exit 1
  mount -o bind /proc rootfs/proc || exit 1
fi
cp -p VERSION rootfs/mnt/live || exit 1
chroot rootfs /usr/lib/magos/scripts/mkinitrd /boot/initrd.gz || exit 1
mv rootfs/boot/initrd.gz "$MYPATH/$DESTDIR/${FLASHNAME}" || exit 1

echo "Перемещение модулей"
cd "$MYPATH/work/$FLASHNAME-$VERREL" || exit 1
mv -f *.$MODULEFORMAT $MYPATH/$DESTDIR/$FLASHNAME/base/
cd "$MYPATH/$DESTDIR/$FLASHNAME/base"
chmod 444 *
md5sum *.$MODULEFORMAT >MD5SUM

cd "$MYPATH"
echo "Создание файлов для сохранения данных" 
cd "$MYPATH"/$DESTDIR/$FLASHNAME-Data || exit 1
[ "$DATASIZE1" != "" ] && dd if=/dev/zero of=${FLASHNAME}_save1.img bs=1M count=$DATASIZE1 && mkfs.ext3 -F -j ${FLASHNAME}_save1.img >/dev/null 2>&1
[ "$DATASIZE2" != "" ] && dd if=/dev/zero of=${FLASHNAME}_save2.img bs=1M count=$DATASIZE2 && mkfs.ext3 -F -j ${FLASHNAME}_save2.img >/dev/null 2>&1

echo "Работа скрипта завершена, в папке flash лежит готовая к установке система :-)"
echo "Запустите скрипт 9_clear_work.sh для удаления сборочной директории work"
exit 0
