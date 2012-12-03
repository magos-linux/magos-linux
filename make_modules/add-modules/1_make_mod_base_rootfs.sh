#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Собирает базовые модули
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

mkdir -p $ROOTFS

if [ "$FS_ROOTFS" = "unionfs" ]
then
  modprobe unionfs
  mount -t unionfs -o dirs=$MOD_PREV wiz_fly $ROOTFS
fi

if [ "$FS_ROOTFS" = "aufs" ]
then
  mount -t aufs wiz_fly -o br:$MOD_PREV $ROOTFS
  mkdir -p $ROOTFS/{proc,dev,sys}
fi

  mount -o bind /proc $ROOTFS/proc
  mount -o bind /dev $ROOTFS/dev
  mount -o bind /sys $ROOTFS/sys

DIR_KERNEL=`ls ./kernel`

for MOD in `ls -1 $MOD_NAMES_DIR/??-*` ;do 
    echo "Генерация rootfs для модуля $(basename $MOD)"
    if [ -d $MOD_ROOTFS_DIR/$(basename $MOD) ] ;then 
	echo "...директория уже создана"
    else
	mkdir -p $MOD_ROOTFS_DIR/$(basename $MOD)
    fi

    MOD_LINE=$MOD_ROOTFS_DIR/$(basename $MOD)
    if [ "$FS_ROOTFS" = "unionfs" ]
    then      
      mount -o remount,rw,add=$MOD_LINE=rw,mode=$MOD_PREV=ro wiz_fly $ROOTFS
    fi
    if [ "$FS_ROOTFS" = "aufs" ]
    then
      mount -o remount,prepend:$MOD_LINE=rw,mod:$MOD_PREV=rr wiz_fly $ROOTFS
    fi
    MOD_PREV=$MOD_LINE
    if [ ! "$DIR_KERNEL" = "" ]
       then
         if [ "$(basename $MOD)" = "00-base-kernel" ]
            then
             urpmi $URPMI_PARAM --urpmi-root=$ROOTFS --root=$ROOTFS ./kernel/* 2>>$MYPATH/work/errors_urpmi.txt
         fi
    fi
    urpmi $URPMI_PARAM --urpmi-root=$ROOTFS --root=$ROOTFS `cat $MOD` 2>>$MYPATH/work/errors_urpmi.txt
    echo -ne \\n "---> OK."\\n
done

echo "В файле work/errors_urpmi.txt содержатся ошибки установки"
