#!/bin/bash

# Описание: Генерирует файлы с зависимостями пакетов модулей для MagOS
# дата: 23.11.2010
# Автор: Горошкин Антон

MOD_NAMES_DIR=mod_names
MOD_ROOTFS_DIR=mod_rootfs
MOD_LZM_DIR=mod_lzm
TOOLS_DIR=tools

mkdir -p $MOD_LZM_DIR

for mod in `ls -1 $MOD_NAMES_DIR/??-*` ;do 
    echo "Генерация lzm для модуля $(basename $mod)"

#--------------
    $TOOLS_DIR/dir2lzm $MOD_ROOTFS_DIR/$(basename $mod) $MOD_LZM_DIR/$(basename $mod).lzm
    echo -ne \\n "---> OK."\\n
done
