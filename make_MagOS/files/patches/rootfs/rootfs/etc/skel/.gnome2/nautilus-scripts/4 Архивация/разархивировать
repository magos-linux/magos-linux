#!/bin/sh
#
#  GUNZIP and BUNZIP2 wrapper for Nautilus Scripts menu.
#
# AUTHOR:  Roberto Piscitello <robepisc@freemail.it>
# VERSION: 1.1
# LICENSE: public domain
# DEPENDENCIES: Nautilus, nautilus-error-dialog | gdialog | xmessage, gzip, bzip2, awk
# CHANGES:
#   v1.1: 17 Mar 2002
#     * made public domain (no more GPL)
#     * removed beep stuff, since it doesn't seem to work
#     * added nautilus-error-dialog support
#     * use "which" to avoid hardcoded paths (as suggested by Dylan Griffiths)
#   v1.0: 21 May 2001
#     * first public release
# INSTALL NOTES:
#   * open a Nautilus window and select, from the menu, File->Script->Open Scripts directory.
#   * copy this file in that directory.
#   * right-click on the copied file and open the Properties window.
#   * from the first tab: (if you want) change its icon (I suggest
#     "/usr/share/pixmaps/nautilus/gnome-compressed.png") and name.
#   * from the third tab: give executable permissions to the file owner.
#

TMP_FILE=`tempfile 2> /dev/null` || TMP_FILE="/tmp/nautilus-script.$$"
IFS="
"

trap "rm -f $TMP_FILE" EXIT

for F in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
	cd `dirname $F`
	if [ `echo $F|awk '{ print substr($0,length($0)-2) }'` = "bz2" -o `echo $F|awk '{ print substr($0,length($0)-1) }'` = "bz" ]; then
		UZIP="bunzip2"
	else
		UZIP="gunzip"
	fi
	if ! $UZIP `basename $F` 2> $TMP_FILE; then
		# Some error happened: show an error message
		if which nautilus-error-dialog; then
			nautilus-error-dialog --title $UZIP --message "`cat $TMP_FILE`."
		elif which gdialog; then
			gdialog --title $UZIP --msgbox "`cat $TMP_FILE`." 20 100
		elif which xmessage; then
			xmessage -buttons OK -file $TMP_FILE
		fi
	fi
done
