#!/bin/bash
# Deprecated in MagOS-Linux
exit 0

# this script is to be called when a locale is removed from the sistem;
# so translations in the language(s) of the locale are no longer installed

if [ "$1" == "ENCODINGS" ]; then
	# remove encoding files used by locales
	ENCODINGS="CP1251 ISO-8859-1 ISO-8859-13 ISO-8859-14 ISO-8859-15 \
		ISO-8859-2 ISO-8859-3 ISO-8859-4 ISO-8859-5 ISO-8859-7 \
		ISO-8859-9 KOI8-R KOI8-U UTF-8"
	for enc in $ENCODINGS; do
		if [ -d "/etc/locale/$enc" ]; then
			for i in LC_ADDRESS LC_COLLATE LC_CTYPE \
			         LC_IDENTIFICATION LC_MEASUREMENT LC_MONETARY \
			         LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE \
			         LC_TIME LC_MESSAGES/SYS_LC_MESSAGES
			do
				rm -f "/etc/locale/$enc/$i"
			done
			rmdir "/etc/locale/$enc/LC_MESSAGES" > /dev/null 2>&1
			rmdir "/etc/locale/$enc" > /dev/null 2>&1
		fi
	done
	exit 0
fi

# the list of languages that rpm installs their translations
if [ -r /etc/rpm/macros ]; then
	RPM_INSTALL_LANG="`grep '^%_install_langs' /etc/rpm/macros | cut -d' ' -f2-`"
fi
[ -z "$RPM_INSTALL_LANG" ] && RPM_INSTALL_LANG=C
OLD_RPM_INSTALL_LANG="$RPM_INSTALL_LANG"

for i in "$@"; do
	langs="$i"
	for j in /usr/share/locale/$i.*; do
		[ -d "$j" ] || continue
		lng=`basename $j`
		# sanity check
		echo $lng | grep -q $i || continue
		langs="$langs $lng"
	done
	for k in $langs; do
		# remove the LC_* of the all system locales from /etc/locale,
		# copied by locale_install.sh
		if [ -d "/etc/locale/$k" ]; then
			for j in LC_ADDRESS LC_IDENTIFICATION LC_MONETARY \
			         LC_PAPER LC_COLLATE LC_MEASUREMENT LC_NAME \
			         LC_TELEPHONE LC_CTYPE LC_NUMERIC LC_TIME \
			         LC_MESSAGES/SYS_LC_MESSAGES
			do
				rm -f "/etc/locale/$k/$j"
			done
			rmdir "/etc/locale/$k/LC_MESSAGES" > /dev/null 2>&1
			rmdir "/etc/locale/$k" > /dev/null 2>&1
		fi
	done

	# remove the locale from the list known to rpm (so translations in that
	# language are no more installed), and from the menu system
	if [ "$RPM_INSTALL_LANG" != "all" ]; then
		RPM_INSTALL_LANG=`perl -e 'print join(":",grep { $_ ne "$ARGV[1]" } sort(split(/:/,$ARGV[0])))' "$RPM_INSTALL_LANG" "$i"`
	fi

	langs="`localedef --list-archive | grep \"$i\"`"
	for lng in $langs; do
		localedef --delete-from-archive $lng
	done
done

if [ "$OLD_RPM_INSTALL_LANG" != "$RPM_INSTALL_LANG" ]; then
	# update /etc/rpm/macros file
	if [ -w /etc/rpm/macros ]; then
		perl -pe "s/^%_install_langs .*/%_install_langs ${RPM_INSTALL_LANG}/" \
		     -i /etc/rpm/macros
	fi
fi
