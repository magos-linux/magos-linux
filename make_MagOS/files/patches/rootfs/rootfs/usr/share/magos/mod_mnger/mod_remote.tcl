#!/bin/bash
# exec wish \
[ $1_ == "_" ] && exec wish "$0" "$@"
# exec tclsh \
[ $1_ == "_" ] || exec tclsh  "$0" "$@"

package require msgcat
proc _ {s} {return [::msgcat::mc $s]}
::msgcat::mcload /usr/share/magos/mod_mnger/msg/

proc checkURL {} {
global URL  protocol server dirname file login
regexp {([^:]+://)(.*@)?(.*)/((.*\..*)$)?} $URL  badURL protocol login server file
puts stdout $badURL
puts stdout PROTOCOL----$protocol
puts stdout LOGIN-------$login
puts stdout SERVER------$server
puts stdout FILE--------$file
set dirname [ file root $file ]
puts stdout DIRNAME-----/mnt/network/$dirname 
if { [ string length $file ] == 0  } {
tk_messageBox -icon warning  -message "there is n o filename in your URL"
} elseif {[file extension $file] ne ".xzm" } {
tk_messageBox -icon warning  -message "file must be .xzm module"
} elseif { "$protocol" eq "http://" } {
httpproc
} elseif { "$protocol" eq "ftp://" } {
ftpproc
} else {
tk_messageBox -icon warning  -message "$protocol \n unsupported protocol"
}
}

proc httpproc {} {
global protocol server file URL dirname
  set y [ file exists "/mnt/network/$dirname" ]
  if { "$y" eq 1 } {
  catch { exec deactivate  $file } result
  puts stdout DEACTIVATE--$result.OK
  catch { exec  umount /mnt/network/$dirname } result
  puts stdout UMOUNT------$result.OK
  } else { 
  file mkdir /mnt/network/$dirname
  }
  catch { exec  httpfs $URL /mnt/network/$dirname } result
  puts stdout MOUNT_HTTP---$result.OK
  catch { exec  activate  /mnt/network/$dirname/$file } result
  puts stdout ACTIVATE----$result
exit
}



proc ftpproc {} {
global dirname file server protocol URL login
set y [ file exists "/mnt/network/$dirname" ]
  if { "$y" eq 1 } {
  catch { exec deactivate  /$file } result
  puts stdout DEACTIVATE--$result.OK
  catch { exec  umount /mnt/network/$dirname } result
  puts stdout UMOUNT------$result.OK
  } else { 
  file mkdir /mnt/network/$dirname
  }  
  catch { exec  curlftpfs $protocol$login$server /mnt/network/$dirname } result
  puts stdout MOUNT_FTP---$result.OK
  catch { exec  activate  /mnt/network/$dirname/$file } result
  puts stdout ACTIVATE----$result
exit
}

set URL $argv
if { "$URL" eq ""} {
frame .top 
pack .top
set bgcolors [ split [ exec /usr/share/magos/mod_mnger/getcolor.tcl ] ] 
tk_setPalette [ lindex $bgcolors 0 ]

labelframe .top.addmodule -text [ _ "Enter module URL" ]
if { [ file exists  /etc/.remote_modules ] == 1 } {
  set conf [open /etc/.remote_modules r]
  seek $conf 0 start
  set  modulelist [read $conf]
  close $conf
} else {
set modulelist {
ftp://
http://
http://magos.sibsau.ru/repository/modules/2011/optional/editors/45-add-editors-2011-neobht/45-add-editors-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/audio/45-add-audio-2011-neobht/45-add-audio-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/graphics/45-add-graphics-2011-neobht/45-add-graphics-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/internet/45-add-internet-2011-neobht/45-add-internet-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/internet/45-add-internet-mib-2011-neobht/45-add-internet-mib-2011-neobht-20111224.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/other/45-add-sapr-2011-neobht/45-add-sapr-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/programming/45-add-programming-2011-neobht/45-add-programming-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/science/45-add-science-2011-neobht/45-add-science-2011-neobht-20111223.xzm
http://magos.sibsau.ru/repository/modules/2011/optional/video/45-add-video-2011-neobht/45-add-video-2011-neobht-20111223.xzm
}
}
ttk::combobox .top.addmodule.url  -values $modulelist -textvariable URL -width 100
button .top.addmodule.button -text [ _ "OK" ] -command  {
	set modulelist $URL\n$modulelist
	set conf [open /etc/.remote_modules w+]
	puts $conf $modulelist
	close $conf
checkURL
}
pack .top.addmodule  -side top
pack .top.addmodule.url .top.addmodule.button -side left
update idletasks
set geometry [split [lindex [split [wm geometry . ] "+"] 0] "x"]
	set w [lindex $geometry end-1]
	set h [lindex $geometry end]
	set x [expr {([winfo screenwidth .]/2 - $w/2)}]
	set y [expr {([winfo screenheight .]/2 - $h/2)}]
	wm geometry . +$x+$y
	wm resizable . 0 0
update idletasks

} else {
checkURL
}

  