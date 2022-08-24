#!/bin/sh
function resolve_loop_link()
{
  if [ -h $1 ] ;then
   rm -f $1
   mkdir -p /tmp$1
   ls $(dirname $1) | while read a ;do
      ln -sf ../$a /tmp$1/$a
   done
   mv /tmp$1 $1
  fi
}
resolve_loop_link /usr/share/zoneinfo/posix
resolve_loop_link /usr/libexec/openssh

