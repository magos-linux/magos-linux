#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Собирает модули в репозиторий для MagOS
# Дата модификации: 03.12.2012
# Авторы: Горошкин Антон

if [ "`id -u`" != "0" ] ;then
   echo "Нужны права root"
   exit 1
fi

if [ -f config ] ;then
  . config
else
  echo "Не вижу файла config" ;  exit 1
fi

function make_mod_pack ()
{
    mod_name=$1
    shift
    mod_br=/mnt/live/memory/tmp/_fly_mods
    root_br=/mnt/live/memory/tmp/_fly_rootfs
    mod_path=/mnt/live/memory/images
 
    mount_br=$mod_br
 
    rm -rf $mount_br $root_br
    mkdir -p $mount_br $root_br
 
    for a in `ls -d $mod_path/??-base*`; do
	mount_br="$mount_br:$a=rr+nowh"
    done
 
    mount -t aufs -o br:$mount_br wiz_fly $root_br
    mkdir -p $root_br/tmp
#    /usr/sbin/urpmi --root=$root_br $@
    /usr/sbin/urpmi $URPMI_PARAM --noclean --root=$root_br $@
    umount wiz_fly
    rm -rf $mod_br/var/lib/rpm
    rm -rf $mod_br/tmp
    if [ $? != 0 ]; then echo "error building modules "; exit 1; fi
    dir2lzm $mod_br $mod_name

    rm -rf $mod_br
}
#---------------


MOD_REP=repository/optional
MOD_NAMES_DIR=mod_names
#URPMI_PARAM="--no-verify-rpm --excludemedia MIB"
URPMI_PARAM="--no-verify-rpm "

mkdir -p  $MOD_REP
mask=$1
for mod in `ls -1 $MOD_NAMES_DIR/add/??-add-*$mask` ;do 
    echo "Генерация метамодуля $(basename $mod)"
    if [ -d $MOD_REP/$(basename $mod) ] ;then 
	echo "...директория уже создана"
#	continue
    else
	mkdir -p $MOD_REP/$(basename $mod)
    fi

#--------------
    pak_list=""
     for pak in `cat $mod` ;do 
        echo -ne \\r "Добавляется пакет $pak         "\\r 
        pak_list="$pak_list $pak"
#        sleep 3
#        urpmi --root=$rootfs --noclean --download-all $MOD_LOADED $1 $pak
#        urpmi --root=$rootfs --noclean $1 $pak
     done
     make_mod_pack $MOD_REP/$(basename $mod)/$(basename $mod)-$(date +%Y%m%d).xzm $pak_list
#--------------
    echo -ne \\n "---> OK."\\n
done
#     umount $rootfs
