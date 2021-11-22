#!/bin/bash
#BUGFIX some lib links was captured by devel packages. 
#We will not install them through the deps, but we will create links to make linked binary happy (if ldconfig did'nt make this job)

function makelink()
{
  if [ ! -h "$2" ] ;then
     DIR=$(dirname "$2")/$(dirname "$1")
     LDIR=$(dirname "$1")/
     [ "$LDIR" = "./" ] && LDIR=
     [ -d "$DIR" ] || continue
     FILE=$(find $DIR | grep -m1 "$1$")
     [ -z "$FILE" ] || ln -s $LDIR$(basename $FILE) "$2"
  fi
}

makelink "../../lib64/libblkid.so.*.*.0"	/usr/lib64/libblkid.so 			#lib64blkid-devel
makelink "libfilezilla.so.*.*.0" 		/usr/lib64/libfilezilla.so 		#lib64filezilla-devel
makelink "libformw.so.." 			/usr/lib64/libformw.so 			#lib64ncurses-devel
makelink "libformw.so" 				/usr/lib64/libform.so 			#lib64ncurses-devel
makelink "libmenuw.so.." 			/usr/lib64/libmenuw.so 			#lib64ncurses-devel
makelink "libmenuw.so" 				/usr/lib64/libmenu.so 			#lib64ncurses-devel
makelink "../../lib64/libncursesw.so.*.*" 	/usr/lib64/libncursesw.so 		#lib64ncurses-devel
makelink "libncursesw.so" 			/usr/lib64/libncurses.so 		#lib64ncurses-devel
makelink "libncursesw.so" 			/usr/lib64/libcurses.so 		#lib64ncurses-devel
makelink "libpanelw.so.." 			/usr/lib64/libpanelw.so 		#lib64ncurses-devel
makelink "libpanelw.so" 			/usr/lib64/libpanel.so 			#lib64ncurses-devel
makelink "libhogweed.so.*.*" 			/usr/lib64/libhogweed.so 		#lib64nettle-devel
makelink "libnettle.so.*.*" 			/usr/lib64/libnettle.so 		#lib64nettle-devel
makelink "libpackagekit-glib2.so.*.*.*"		/usr/lib64/libpackagekit-glib2.so 	#lib64packagekit-devel
makelink "libpugixml.so.." 			/usr/lib64/libpugixml.so 		#lib64pugixml-devel
makelink "../../lib/libstdc++.so.*.*.*"		/usr/lib/libstdc++.so 			#lib64stdc++-devel
makelink "../../lib64/libstdc++.so.*.*.*" 	/usr/lib64/libstdc++.so  		#lib64stdc++-devel
makelink "libudev.so.." 			/lib64/libudev.so 			#lib64udev-devel

exit 0

lib64gcc-devel ?