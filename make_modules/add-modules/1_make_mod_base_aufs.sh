#!/bin/bash

# Описание: Собирает базовые модули для MagOS на основе aufs
# Дата модификации: 07.11.2012
# Автор: Горошкин Антон

MOD_NAMES_DIR=mod_names
MOD_ROOTFS_DIR=mod_rootfs
mod_prev=$MOD_ROOTFS_DIR/ro
rootfs=$MOD_ROOTFS_DIR/rootfs

mkdir -p $rootfs 


mount -t aufs wiz_fly -o br:$mod_prev $rootfs

for mod in `ls -1 $MOD_NAMES_DIR/??-base*` ;do 
    echo "Генерация rootfs для модуля $(basename $mod)"
    if [ -d $MOD_ROOTFS_DIR/$(basename $mod) ] ;then 
	echo "...директория уже создана"
#	continue
    else
	mkdir -p $MOD_ROOTFS_DIR/$(basename $mod)
    fi

    mod_line=$MOD_ROOTFS_DIR/$(basename $mod)
    mount -o remount,prepend:$mod_line=rw,mod:$mod_prev=rr wiz_fly $rootfs
    mod_prev=$mod_line
#--------------
#     for pak in `cat $mod` ;do 
#        echo -ne \\r "Добавляется пакет $pak         "\\r 
#        sleep 3
#        urpmi --root=$rootfs --noclean --download-all $MOD_LOADED $1 $pak
#        urpmi --root=$rootfs --noclean $1 $pak
#     done
        urpmi --urpmi-root=$rootfs --root=$rootfs --noclean $1 `cat $mod`
#--------------
    echo -ne \\n "---> OK."\\n
done
     umount $rootfs
