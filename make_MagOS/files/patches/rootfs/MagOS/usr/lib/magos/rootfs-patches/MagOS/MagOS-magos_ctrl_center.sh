#!/bin/bash
[ -d /usr/share/magos-ctrl-center/items ] || exit 0
sed -i /drakgw/d /usr/share/magos-ctrl-center/items/advanced
sed -i /drakgw/d /usr/share/magos-ctrl-center/items/x0002x
sed -i s=/usr/bin/modmnger=/usr/lib/magos/scripts/modmnger= /usr/share/magos-ctrl-center/items/x0001x
exit 0
