#!/bin/bash
PFP=etc/PolicyKit/PolicyKit.conf
grep -q "org.freedesktop.hal.storage.mount-fixed" $PFP && exit 0
sed -i /^'<\/config>'/d $PFP
cat >> $PFP <<EOF

  <match action="org.freedesktop.hal.storage.mount-fixed">
         <return result="yes"/>
  </match>
  <match action="org.freedesktop.hal.power-management.shutdown">
         <return result="yes"/>
  </match>
  <match action="org.freedesktop.hal.power-management.reboot">
         <return result="yes"/>
  </match>
  <match action="org.freedesktop.hal.power-management.suspend">
         <return result="yes"/>
  </match>
  <match action="org.freedesktop.hal.power-management.hibernate">
         <return result="yes"/>
  </match>

</config>
EOF
exit 0
