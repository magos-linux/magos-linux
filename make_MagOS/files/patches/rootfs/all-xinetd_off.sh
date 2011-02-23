#!/bin/bash

for a in etc/xinetd.d/* ;do
   [ -e $a ] && sed -i s/"^[[:space:]]*disable[[:space:]].*"/"        disable = yes"/ $a
done


exit 0
