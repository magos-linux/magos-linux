#!/bin/bash

[ -f /usr/share/applications/doublecmd.desktop ] || mv -f /usr/share/applications/doublecmd-qt.desktop /usr/share/applications/doublecmd.desktop

PFP=/usr/lib/doublecmd
[ -d "$PFP" ] || PFP=/usr/lib64/doublecmd
[ -d "$PFP" ] || exit 0
PFP=$PFP/doublecmd.xml
[ -f "$PFP" ] || echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<doublecmd DCVersion=\"0.9.10 beta\" ConfigVersion=\"10\">\n</doublecmd>" > $PFP
grep -q [*][.]xzm $PFP && exit 0
sed -i /'<\/doublecmd>'/d $PFP
cat >>$PFP <<EOF
  <Behaviours>
    <AutoFillColumns>True</AutoFillColumns>
    <DriveBlackList>/dev/loop*;*.xzm;none;</DriveBlackList>
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
