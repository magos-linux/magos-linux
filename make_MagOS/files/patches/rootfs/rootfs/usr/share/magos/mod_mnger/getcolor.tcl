#!/bin/bash
# exec tclsh \
exec tclsh  "$0" "$@"
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

# цвета KDE ------------------------------------------------------------------------------
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
#------------------------------------------------------------------------------------------


 puts stdout $bg1
 puts stdout $bg2
