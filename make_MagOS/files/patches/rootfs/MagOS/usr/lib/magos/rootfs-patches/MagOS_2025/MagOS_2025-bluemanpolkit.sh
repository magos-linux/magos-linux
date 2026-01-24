#!/bin/bash

PFP=/etc/polkit-1/rules.d/81-blueman.rules
[ -f "$PFP"  ] && exit 0
cat > "$PFP" <<EOF
polkit.addRule(function(action, subject) {
  if (action.id == "org.blueman.rfkill.setstate" && subject.local && subject.active && subject.isInGroup("users")) {
      return polkit.Result.YES;
  }
  if (action.id == "org.blueman.network.setup" && subject.local && subject.active && subject.isInGroup("users")) {
      return polkit.Result.YES;
  }
});
EOF

exit 0
