#!/bin/bash
[ -d /usr/share/magos-ctrl-center/items ] || exit 0
sed -i /drakgw/d /usr/share/magos-ctrl-center/items/advanced
sed -i /drakgw/d /usr/share/magos-ctrl-center/items/x0002x
exit 0
