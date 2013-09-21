#!/bin/sh
#
# Nautilus Script:
#   Show the parameters passed by nautilus.
#
# Owner: 
#   Barak Korren
#   ifireball@yahoo.com
#
# Licence: GNU GPL
# Copyright (C) Barak Korren
#
# Dependency:
#   xmessage
#
# Change log:
#   Mon, Apr 05, 2004 - Created.
#
# Known Issues:
#   I'd like to use zentity instead of xmessage, but it doesn't currently 
#   support showing text from the standard input, too bad gless doesn't seem 
#   to be shipped with gnome-utils anymore, maybe one can use the builtin 
#   Nautilus text viewer?
#

(
echo "AGRS"
for arg in "$@"; do
  echo "\"$arg\""
done
echo NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
echo NAUTILUS_SCRIPT_SELECTED_URIS
echo -e "$NAUTILUS_SCRIPT_SELECTED_URIS"
echo NAUTILUS_SCRIPT_CURRENT_URI
echo -e "$NAUTILUS_SCRIPT_CURRENT_URI"
echo NAUTILUS_SCRIPT_WINDOW_GEOMETRY
echo -e "$NAUTILUS_SCRIPT_WINDOW_GEOMETRY"
) | xmessage -file -
