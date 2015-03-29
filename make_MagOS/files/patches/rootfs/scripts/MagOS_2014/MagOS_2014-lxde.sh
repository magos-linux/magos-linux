#!/bin/bash
#free space by using common icon theme
if [ -d usr/share/icons/rosa -a -d usr/share/icons/rosa-flat ] ;then
   rm -fr usr/share/icons/rosa-flat
   ln -sf rosa usr/share/icons/rosa-flat
fi

