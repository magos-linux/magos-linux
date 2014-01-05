#!/bin/bash
mkdir -p usr/share/mdk/about
ln -sf index-ru-magos.html usr/share/mdk/about/index-ru.html
ln -sf index-ru-magos.html usr/share/mdk/about/index.html
rm -f usr/share/mdk/desktop/free/*
exit 0
