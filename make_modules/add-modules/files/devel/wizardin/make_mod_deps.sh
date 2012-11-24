#!/bin/bash

# Описание: Генерирует файлы с зависимостями пакетов модулей и списки общих пакетов в модуле (common_deps_*) и список общих пакетов между модулями (common_packages) для MagOS
# дата: 01.12.2010
# Автор: Антон Горошкин 
 
MOD_NAMES_DIR=mod_names
MOD_ROOTFS_DIR=mod_rootfs

mod_prev=$MOD_ROOTFS_DIR/ro
rootfs=$MOD_ROOTFS_DIR/rootfs

mkdir -p $rootfs $mod_prev 


mount_br="$mod_prev=rr"
mod_path=/mnt/live/memory/images
for a in `ls -d $mod_path/??-*`; do
    mount_br="$mount_br:$a=rr"
done
mod_prev=$mount_br
echo  $mod_prev
 
mount -t aufs -o xino=xinofile,br:$mod_prev=rr none $rootfs



for mod in `ls -1 $MOD_NAMES_DIR/??-*` ;do 
    echo "Генерация файла зависимостей для модуля $(basename $mod)"

#--------------
    mkdir -p $MOD_NAMES_DIR/deps
   [ -f $MOD_NAMES_DIR/deps/$(basename $mod) ]&&rm $MOD_NAMES_DIR/deps/$(basename $mod)
   [ -f $MOD_NAMES_DIR/deps/common_$(basename $mod) ]&&rm $MOD_NAMES_DIR/deps/common_$(basename $mod)

    for pak in `cat $mod` ;do 
      echo -ne \\r "Добавляются зависимости пакета $pak         "\\r 
#      urpmq --root=$rootfs -d $1 $pak >>$MOD_NAMES_DIR/deps/_$(basename $mod)
      urpmq --root=$rootfs -m $pak >>$MOD_NAMES_DIR/deps/_$(basename $mod)
    done
#--------------
    sort -u $MOD_NAMES_DIR/deps/_$(basename $mod)>$MOD_NAMES_DIR/deps/dep_$(basename $mod)
    sort $MOD_NAMES_DIR/deps/_$(basename $mod)| uniq -d >$MOD_NAMES_DIR/deps/common_$(basename $mod)

    cat $MOD_NAMES_DIR/deps/common_$(basename $mod) > $MOD_NAMES_DIR/deps/$(basename $mod)
    cat $mod >>$MOD_NAMES_DIR/deps/$(basename $mod)
    
    rm $MOD_NAMES_DIR/deps/_*
    echo -ne \\n "---> OK."\\n
done

    cat $MOD_NAMES_DIR/deps/??-* | sort | uniq -d >$MOD_NAMES_DIR/common_packages
    umount $rootfs
