#!/bin/sh
#
# This script removes executable bit from all files (excluding directories!)
# recursively. Very useful when you copy files from MS Win partition or from a
# CD recorded on Windows.
#
# Author: Krzysztof Luks <m00se@iq.pl>
#
# Copyright (C) 2002 Krzysztof Luks
# Licence: GNU GPL 2 or later.
#

# set desired mode here
MODE="644"

# We don't want to split NAUTILUS_SCRIPT_SELECTED_FILE_PATHS on spaces.
IFS="
"

for ARG in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
	if [ -d "$ARG" ]
	then
		for FILE in `find "$ARG" -type f`
		do
			chmod -f $MODE "$FILE"
		done
	elif [ -f "$ARG" ]
	then
		chmod -f $MODE "$ARG"
	fi
done

