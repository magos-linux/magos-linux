#!/bin/bash
grep -q XkbLayout usr/bin/startlxde && exit 0

echo '#!/bin/sh' >usr/bin/startlxde.new
echo '. /etc/sysconfig/keyboard ; setxkbmap $XkbLayout' >>usr/bin/startlxde.new
grep -v '#!/bin/sh' usr/bin/startlxde >> usr/bin/startlxde.new
cat  usr/bin/startlxde.new > usr/bin/startlxde
rm -f usr/bin/startlxde.new

exit 0
