#!/bin/bash
 
# Описание: Собирает модули в метапакеты для MagOS
# Дата: 01.12.2010
# Автор: Антон Горошкин

#PROXY=http://portage_user:1qaz@ns:3128
#export $PROXY

MOD_LOADED=loaded
MOD_NAMES_DIR=mod_names
MOD_ROOTFS_DIR=mod_rootfs
mod_br=/mnt/live/memory/tmp/_fly_mods


mod_prev=$MOD_ROOTFS_DIR/ro
rootfs=$MOD_ROOTFS_DIR/rootfs
 
mkdir -p $rootfs $mod_prev $MOD_LOADED
 
mount_br="$mod_prev=rr"
mod_path=/mnt/live/memory/images
for a in `ls -d $mod_path/??-*`; do
    mount_br="$mount_br:$a=rr"
done
mod_prev=$mount_br
echo  $mod_prev
 
mount -t aufs -o xino=xinofile,br:$mod_prev=rr none $rootfs
 
for mod in `ls -1 $MOD_NAMES_DIR/??-*` ;do 
    echo "Генерация rootfs для модуля $(basename $mod)"
    if [ -d $MOD_ROOTFS_DIR/$(basename $mod) ] ;then 
	echo "...директория уже создана"
#	continue
    else
	mkdir -p $MOD_ROOTFS_DIR/$(basename $mod)
    fi

 echo "Описание: метамодуль $(basename $mod)" >$MOD_ROOTFS_DIR/$(basename $mod)/description.ini
 echo "Дата создания: `date +%F`" >>$MOD_ROOTFS_DIR/$(basename $mod)/description.ini
 echo -ne \\n"Содержание:" \\n\\n >>$MOD_ROOTFS_DIR/$(basename $mod)/description.ini
 

#     for pak in `cat $MOD_NAMES_DIR/common_$(basename $mod)` ;do 
	pak=`cat $MOD_NAMES_DIR/deps/common_$(basename $mod)`
        echo -ne \\r "Добавляется пакет $pak         "\\r 
        
        mod_line=$MOD_ROOTFS_DIR/$(basename $mod)/common_pak
        mkdir -p $mod_line
        
	mount -o remount,prepend:$mod_line=rw,mod:$mod_prev=rr+nowh none $rootfs
	mod_prev=$mod_line
#        sleep 3
#        urpmi --root=$rootfs --noclean --download-all $MOD_LOADED $1 $pak
        urpmi --root=$rootfs --noclean $1 $pak
#     done

#--------------
     for pak in `cat $mod` ;do 
        echo -ne \\r "Добавляется пакет $pak         "\\r 
        
        mod_line=$MOD_ROOTFS_DIR/$(basename $mod)/$pak
        mkdir -p $mod_line
        
	mount -o remount,prepend:$mod_line=rw,mod:$mod_prev=rr+nowh none $rootfs
	mod_prev=$mod_line
#        sleep 3
#        urpmi --root=$rootfs --noclean --download-all $MOD_LOADED $1 $pak
        urpmi --root=$rootfs --noclean $1 $pak
     done
#--------------
    cat $mod >>$MOD_ROOTFS_DIR/$(basename $mod)/description.ini

    echo -ne \\n "---> OK."\\n
    
done
     umount $rootfs
     