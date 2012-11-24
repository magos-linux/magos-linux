#!/bin/bash
# exec wish \
exec wish8.6 "$0" "$@"
package require msgcat
package require Tk
proc _ {s} {return [::msgcat::mc $s]}
::msgcat::mcload /usr/share/magos/mod_mnger/msg/

set w .ttkprogress
catch {destroy $w}
frame $w 
pack $w -fill both -expand yes
wm title . [ _ "Please wait..." ]
wm geometry . 350x80
wm transient .

label $w.msg   -text $argv  -justify left  
pack $w.msg -side top -fill both -expand yes

ttk::progressbar $w.p1 -mode indeterminate 
pack $w.p1  -fill both -expand yes -padx 5 -pady 5

label $w.bottom   -text ""   
pack $w.bottom -side bottom -fill both -expand yes
update idletasks
set geometry [split [lindex [split [wm geometry .] "+"] 0] "x"]
	set width [lindex $geometry end-1]
	set height [lindex $geometry end]
	set x [expr {([winfo screenwidth .]/2 - $width/2)}]
	set y [expr {([winfo screenheight .]/2 - $height/2)}]
	wm geometry . +$x+$y
	wm resizable . 0 0
set bgcolors [ split [ exec /usr/share/magos/mod_mnger/getcolor.tcl ] ] 
tk_setPalette [ lindex $bgcolors 0 ]
update idletasks

$w.p1 start 

proc newlabel { par args } {
global w
$w.msg configure $par $args
} 

proc bottomlabel { par args } {
global w
$w.bottom configure $par $args
} 

proc newwm {text} {
global w
wm title . $text}

proc filesize {} {
global argv
newwm [ _ "Please wait, copying..." ]
newlabel -text [ file tail $argv ]
while { true } {
catch { split [ exec du -h $argv ] } a
after 300
bottomlabel -text ---[ lindex $a 0 ]--- 
update
 }
}


tkwait visibility $w.p1
after 300 
while { [file exists $argv] == 0 } {
after 100
update
}  
filesize
