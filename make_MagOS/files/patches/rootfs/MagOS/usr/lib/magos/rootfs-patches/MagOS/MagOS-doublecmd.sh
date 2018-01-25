#!/bin/bash
FILE=/usr/lib/doublecmd/doublecmd.xml
[ -f $FILE ] || FILE=/usr/lib64/doublecmd/doublecmd.xml
[ -f $FILE ] || exit 0
grep -q [*][.]xzm $FILE && exit 0
sed -i /'<\/doublecmd>'/d $FILE
cat >>$FILE <<EOF
  <Behaviours>
    <AutoFillColumns>True</AutoFillColumns>
    <DriveBlackList>/dev/loop*;*.xzm</DriveBlackList>
  </Behaviours>
  <Miscellaneous>
    <GridVertLine>True</GridVertLine>
    <GridHorzLine>True</GridHorzLine>
    <SpaceMovesDown>False</SpaceMovesDown>
  </Miscellaneous>
  <Icons>
    <Size>16</Size>
  </Icons>
</doublecmd>
EOF
exit 0
