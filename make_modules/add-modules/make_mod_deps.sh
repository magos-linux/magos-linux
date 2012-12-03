#!/bin/bash

# Лицензия: GPL последней версии
# Описание: Генерирует файлы с зависимостями пакетов модулей для MagOS
# Дата модификации: 03.12.2012
# Автор: Горошкин Антон

if [ "`id -u`" != "0" ] ;then
  echo "Нужны права root"
  exit 1
fi
      
if [ -f .config ] ;then
    . .config
else
    echo "Не вижу файла .config" ;  exit 1
fi

rm work/errors

for mod in `ls -1 $MOD_NAMES_DIR/??-*` ;do 
    echo "Генерация файла зависимостей для модуля $(basename $mod)"

#--------------
     [ -f $MOD_NAMES_DIR/deps_$(basename $mod) ]&&rm $MOD_NAMES_DIR/deps_$(basename $mod)

#     urpmq -d --no-suggests --urpmi-root=$MOD_PREV --root=$MOD_PREV `cat $mod` |sort -u >$MOD_NAMES_DIR/deps_$(basename $mod)
     urpmq -d --no-suggests --auto-select --force  --urpmi-root=$MOD_PREV --root=$MOD_PREV `cat $mod`  2>> work/errors |sort -u >$MOD_NAMES_DIR/deps_$(basename $mod)
#--------------
    echo -ne \\n "---> OK."\\n
done
    cat $MOD_NAMES_DIR/deps_* |sort -u >$MOD_NAMES_DIR/full_deps
