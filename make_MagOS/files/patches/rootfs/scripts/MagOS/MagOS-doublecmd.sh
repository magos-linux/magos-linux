#!/bin/bash
# drive bar was disabled because it shows all loop devices(
FILE=usr/lib/doublecmd/doublecmd.xml
[ -f $FILE ] || FILE=usr/lib64/doublecmd/doublecmd.xml
[ -f $FILE ] || exit 0
sed -i /'<\/doublecmd>'/d $FILE
cat >>$FILE <<EOF
  <Layout>
    <DriveBar1>False</DriveBar1>
  </Layout>
</doublecmd>
EOF
