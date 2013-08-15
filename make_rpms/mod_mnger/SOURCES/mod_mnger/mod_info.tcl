#!/bin/bash
# exec wish \
exec wish  "$0" "$@"
package require msgcat
proc _ {s} {return [::msgcat::mc $s]}
::msgcat::mcload /usr/share/magos/mod_mnger/msg/
wm title . $argv

set bgcolors [ split [ exec /usr/share/magos/mod_mnger/getcolor.tcl ] ] 
tk_setPalette [ lindex $bgcolors 0 ]

ttk::setTheme alt
ttk::style configure TLabelframe -background  [ lindex $bgcolors 0 ]
ttk::style configure TLabelframe.Label -background  [ lindex $bgcolors 0 ] 
ttk::style configure TFrame -background  [ lindex $bgcolors 1 ]
ttk::style configure TLabel -background  [ lindex $bgcolors 0 ]

set filename [ file root [file tail $argv]]
ttk::frame .info 
pack .info -expand yes  -fill both
ttk::label .info.modsize -text [ _ "Module size: wait..."] -justify left
ttk::label .info.expandsize -text [ _ "Extract size: wait..."] -justify left
pack .info.modsize .info.expandsize -side top -fill both -expand yes
ttk::labelframe .info.doc -text [ _ "Documentation" ]
ttk::label .info.doc.label -text /usr/share/doc/modules/$filename
ttk::labelframe .info.list -text [ _ "RPM packages list" ]
ttk::label .info.list.label -text /var/lib/rpm/modules/$filename
pack .info.doc .info.list -side left -padx 1 -pady 1 -fill both -expand yes
pack .info.doc.label .info.list.label -side top -padx 1 -pady 1 -fill both -expand yes

  set docs [ text .info.doc.text -height 20 -width 50 -bg [ lindex $bgcolors 1 ] ]
  scrollbar .info.doc.yscroll -orient vert
  .info.doc.text conf -yscrollcommand {.info.doc.yscroll set}
  .info.doc.yscroll conf -command {.info.doc.text yview}
  pack .info.doc.yscroll -expand no -fill both -side right
  pack .info.doc.text  -padx 1 -pady 1 -side top -fill both -expand yes
  $docs insert end [ _ "wait..."]

  set lists [ text .info.list.text -height 20 -width 50  -bg [ lindex $bgcolors 1 ] ]
  scrollbar .info.list.yscroll -orient vert
  .info.list.text conf -yscrollcommand {.info.list.yscroll set}
  .info.list.yscroll conf -command {.info.list.text yview}
  pack .info.list.yscroll -expand no -fill both -side right
  pack .info.list.text  -padx 1 -pady 1 -side top -fill both -expand yes
  $lists insert end [ _ "wait..."]
update idletasks
set geometry [split [lindex [split [wm geometry . ] "+"] 0] "x"]
	set w [lindex $geometry end-1]
	set h [lindex $geometry end]
	set x [expr {([winfo screenwidth .]/2 - $w/2)}]
	set y [expr {([winfo screenheight .]/2 - $h/2)}]
	wm geometry . +$x+$y
	wm resizable . 0 0
update idletasks
catch {send mod_mnger geometry .addmodule}
file mkdir /tmp/squash/$filename
catch {exec mount -t squashfs -o loop -o ro $argv /tmp/squash/$filename} return
if { $return != "" } { 
tk_messageBox -icon warning  -message [ _ "module mount error" ]
catch { send mod_mnger destroy .addmodule }
exit
}
  set doc_file /tmp/squash/$filename/usr/share/doc/modules/$filename.$env(LANG)
  set test_exist [file exists $doc_file]
      if {$test_exist == 0} {
  set doc_file /tmp/squash/$filename/usr/share/doc/modules/$filename
  set test_exist [file exists $doc_file]
      }
   if {$test_exist == 0} {
   set doc_text  [ _ "no text" ]
   } else {
  set doc_read [open $doc_file r]
  seek $doc_read 0 start
  set  doc_text  [read $doc_read]
  close $doc_read
  }
set list_file /tmp/squash/$filename/var/lib/rpm/modules/$filename
  set test_exist [file exists $list_file]
    if {$test_exist == 0} {
  set list_text  [ _ "no list" ]
    } else {
  set list_read [open $list_file r]
  seek $list_read 0 start
  set  list_text  [read $list_read]
  close $list_read
}
set compress [ exec du -s -h $argv ]
split $compress
set expand  [ exec du -s -h /tmp/squash/$filename ]
split $expand

$docs delete 1.0 2.0 
$lists delete 1.0 2.0

$docs insert end $doc_text
$lists insert end $list_text
.info.modsize configure -text "[ _ "Module size:" ] [ lindex $compress 0 ]" 
.info.expandsize configure -text "[ _ "Extract size:" ] [ lindex $expand 0 ]" 
catch {exec umount /tmp/squash/$filename} return
puts stdout $return
file delete /tmp/squash/$filename
