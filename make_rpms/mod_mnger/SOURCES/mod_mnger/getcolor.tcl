#!/bin/bash
# exec tclsh \
exec tclsh  "$0" "$@"


  set datapath /mnt/live/etc/modules
  set path_ /mnt/livemedia/MagOS
  set test_exist [file exists $datapath]
    if {$test_exist == 0} {
    set path_ /mnt/livemedia/MagOS-Data
    } else {
  set datapath_read [open $datapath r]
  seek $datapath_read 0 start
  set  datapath_string  [read $datapath_read]}
      if { [string match *MagOS-Data* $datapath_string] eq "1" }  {
      set path_ /mnt/livemedia/MagOS-Data
      } 
# цвета KDE ------------------------------------------------------------------------------
  set kdecfg /usr/share/magos/kde4/share/config/kdeglobals
  set test_exist [file exists $kdecfg]
	if {$test_exist == 1} {
  set theme_file [open /usr/share/magos/kde4/share/config/kdeglobals ]
  seek $theme_file 100 start
  set  theme  [read $theme_file]
  close $theme_file
  split $theme
  set parttheme [ split [ lrange $theme [ lsearch $theme *Colors:View* ] end ] ]
  set colorRGB [ split [lindex [ split [lindex $parttheme [ lsearch $parttheme BackgroundNormal* ]] "="] 1] ","]
  set bg2 [ format "#%02X%02X%02X" [lindex $colorRGB 0] [lindex $colorRGB 1] [lindex $colorRGB 2]]
  set parttheme [ split [ lrange $theme [ lsearch $theme *Colors:Window* ] end ] ]
  set colorRGB [ split [lindex [ split [lindex $parttheme [ lsearch $parttheme BackgroundNormal* ]] "="] 1] ","]
  set bg1 [ format "#%02X%02X%02X" [lindex $colorRGB 0] [lindex $colorRGB 1] [lindex $colorRGB 2]]
  } else {
  set bg1 #DBEBDE
  set bg2 #F0FFEC
  }
# цвета GTK ------------------------------------------------------------------------------ 
  #set theme_file [open /etc/gtk-2.0/gtkrc ]
  #seek $theme_file 0 start
  #set  theme  [read $theme_file]
  #close $theme_file
  #split $theme
  #set  bgcolor [ split [ lindex $theme [ lsearch $theme *bg_color* ] ]] 
  #set bg1  [ lindex [ split [ lindex $bgcolor [ lsearch $bgcolor  bg_color* ] ] ":"] 1 ]
  #set bg2  [ lindex [ split [ lindex $bgcolor [ lsearch $bgcolor  base_color* ] ] ":"] 1 ]
#-----------------------------------------------------------------------------------------

 puts stdout $bg1
 puts stdout $bg2
