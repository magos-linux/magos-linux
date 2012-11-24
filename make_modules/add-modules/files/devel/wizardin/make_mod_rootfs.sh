#!/bin/bash

# Описание: Собирает модули для MagOS
# Дата: 23.11.2010
# Автор: Горошкин Антон

MOD_LOADED=loaded
MOD_NAMES_DIR=mod_names
MOD_ROOTFS_DIR=mod_rootfs
mod_prev=$MOD_ROOTFS_DIR/ro
rootfs=$MOD_ROOTFS_DIR/rootfs

mkdir -p $rootfs $MOD_LOADED


mount -t aufs none -o br:$mod_prev=rr $rootfs

for mod in `ls -1 $MOD_NAMES_DIR/??-base*` ;do 
    echo "Генерация rootfs для модуля $(basename $mod)"
    if [ -d $MOD_ROOTFS_DIR/$(basename $mod) ] ;then 
	echo "...директория уже создана"
#	continue
    else
	mkdir -p $MOD_ROOTFS_DIR/$(basename $mod)
    fi

    mod_line=$MOD_ROOTFS_DIR/$(basename $mod)
    mount -o remount,prepend:$mod_line=rw,mod:$mod_prev=rr+nowh none $rootfs
    mod_prev=$mod_line
#--------------
     for pak in `cat $mod` ;do 
        echo -ne \\r "Добавляется пакет $pak         "\\r 
#        sleep 3
#        urpmi --root=$rootfs --noclean --download-all $MOD_LOADED $1 $pak
#        urpmi --root=$rootfs --noclean $1 $pak
        urpmi --urpmi-root=$rootfs --root=$rootfs --noclean $1 $pak
     done
#--------------
    echo -ne \\n "---> OK."\\n
done
     umount $rootfs
