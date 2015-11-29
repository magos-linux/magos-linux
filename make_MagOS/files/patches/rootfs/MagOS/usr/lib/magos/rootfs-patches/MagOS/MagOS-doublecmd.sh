#!/bin/bash
# drive bar was disabled because it shows all loop devices(
FILE=/usr/lib/doublecmd/doublecmd.xml
[ -f $FILE ] || FILE=/usr/lib64/doublecmd/doublecmd.xml
[ -f $FILE ] || exit 0
if grep -qi '<DriveBar1>' $FILE ;then
   sed -i s='<DriveBar1>'.*'</DriveBar1>'='<DriveBar1>False</DriveBar1>'= $FILE
else
sed -i /'<\/doublecmd>'/d $FILE
cat >>$FILE <<EOF
  <Layout>
    <DriveBar1>False</DriveBar1>
  </Layout>
</doublecmd>
EOF
fi
exit 0
