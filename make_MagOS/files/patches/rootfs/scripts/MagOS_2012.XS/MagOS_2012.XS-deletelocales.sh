#!/bin/bash
TMPF=usr/share/locales.save
mkdir $TMPF
mv usr/share/locales/UTF-8        $TMPF
mv usr/share/locales/ISO-8859-1   $TMPF
mv usr/share/locales/en_US        $TMPF
mv usr/share/locales/en_US.UTF-8  $TMPF
mv usr/share/locales/ru           $TMPF
mv usr/share/locales/ru_RU        $TMPF
mv usr/share/locales/ru_*.UTF-8   $TMPF
mv usr/share/locales/locale.alias $TMPF
rm -fr usr/share/locales
mv $TMPF usr/share/locales
