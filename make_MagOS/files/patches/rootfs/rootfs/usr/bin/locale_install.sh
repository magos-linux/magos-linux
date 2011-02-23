#!/bin/bash
# deprecated MagOS-Linux
exit 0

# this script is to be called when a locale is installed for first time;
# it gets the locale name(s) as parameter, and does the needed steps
# so that the new locale can be used by the system

# check if installing main locales package (just encodings)
if [ "$1" == "ENCODINGS" ]; then
	# update encoding files used by locales
	ENCODINGS="CP1251 ISO-8859-1 ISO-8859-13 ISO-8859-14 ISO-8859-15 \
		ISO-8859-2 ISO-8859-3 ISO-8859-4 ISO-8859-5 ISO-8859-7 \
		ISO-8859-9 KOI8-R KOI8-U UTF-8"
	for enc in $ENCODINGS; do
		if [ -r "/usr/share/locale/$enc/LC_CTYPE" ]; then
			mkdir -p "/etc/locale/$enc/LC_MESSAGES"
			for i in LC_ADDRESS LC_COLLATE LC_CTYPE \
			         LC_IDENTIFICATION LC_MEASUREMENT LC_MONETARY \
			         LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE \
			         LC_TIME LC_MESSAGES/SYS_LC_MESSAGES
			do
				cp -fp "/usr/share/locale/$enc/$i" \
				       "/etc/locale/$enc/$i"
			done
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

# remove/update locale-archive based on system wide configuration
[ -r /etc/sysconfig/locales ] && . /etc/sysconfig/locales
case "$USE_LOCARCHIVE" in
	yes|true|1)
		update_locarchive=1
		;;
	*)
		update_locarchive=0
		rm -f /usr/share/locale/locale-archive
		;;
esac

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
		# copy the LC_* of the all system locales to /etc/locale, so
		# everything is ok on boot time, even if /usr is not mounted
		if [ -r "/usr/share/locale/$k/LC_CTYPE" ]; then
			mkdir -p "/etc/locale/$k/LC_MESSAGES"
			for j in LC_ADDRESS LC_IDENTIFICATION LC_MONETARY \
			         LC_PAPER LC_COLLATE LC_MEASUREMENT LC_NAME \
			         LC_TELEPHONE LC_CTYPE LC_NUMERIC LC_TIME \
			         LC_MESSAGES/SYS_LC_MESSAGES
			do
				cp -fpP "/usr/share/locale/$k/$j" \
				        "/etc/locale/$k/$j"
			done

			# maintain updated locale-archive file
			[ "$update_locarchive" -eq 0 ] || \
				localedef \
				 --replace \
				 --add-to-archive "/usr/share/locale/$k" \
				> /dev/null
		fi
	done

	# make the installed locale known to rpm (so translations in that
	# language are installed), and the menu system
	if [ "$RPM_INSTALL_LANG" != "all" ]; then
		RPM_INSTALL_LANG=`perl -e 'print join(":",grep { ! $seen{$_} ++ } sort(split(/:/,$ARGV[0])))' "$i:$RPM_INSTALL_LANG"`
	fi
done

if [ "$OLD_RPM_INSTALL_LANG" != "$RPM_INSTALL_LANG" ]; then
	# update /etc/rpm/macros file
	if [ -w /etc/rpm/macros ]; then
		perl -pe "s/^%_install_langs .*/%_install_langs ${RPM_INSTALL_LANG}/" \
		     -i /etc/rpm/macros
	fi
fi
