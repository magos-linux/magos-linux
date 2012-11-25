#!/bin/bash
# root test \
[ "$(id -un)" != "root" ] &&  gksu -g "/bin/bash $0 $@" && exit 0
# exec wish \
exec wish8.6 "$0" "$@"

package require msgcat
proc _ {s} {return [::msgcat::mc $s]}
::msgcat::mcload /usr/share/magos/mod_mnger/msg/
wm title . [ _ "Create and convert MagOS modules" ]
 
set bgcolors [ split [ exec /usr/share/magos/mod_mnger/getcolor.tcl ] ] 
tk_setPalette [ lindex $bgcolors 0 ]

ttk::setTheme alt
ttk::style configure TScrollbar -background  [ lindex $bgcolors 0 ]
ttk::style map  TScrollbar -background [list  active [ lindex $bgcolors 1 ] selected [ lindex $bgcolors 0 ] disabled [ lindex $bgcolors 0 ]]
ttk::style configure TButton -background  [ lindex $bgcolors 0 ]
ttk::style map  TButton -background [list  active [ lindex $bgcolors 1 ]]
ttk::style configure TMenubutton -background  [ lindex $bgcolors 0 ]
ttk::style map  TMenubutton -background [list  active [ lindex $bgcolors 1 ]]
ttk::style configure TFrame -background  [ lindex $bgcolors 1 ]
ttk::style configure TLabel -background  [ lindex $bgcolors 1 ]
ttk::style configure TRadiobutton -background [ lindex $bgcolors 1 ]
ttk::style map  TRadiobutton -background [list  active [ lindex $bgcolors 0]]
ttk::style configure TNotebook -background [ lindex $bgcolors 1 ] -expand yes
ttk::style configure TNotebook.Tab -background [ lindex $bgcolors 0 ] -expand yes
ttk::style map TNotebook.Tab -background [list  active [ lindex $bgcolors 0 ] selected [ lindex $bgcolors 1 ]] 
	

# тексты для help 
set help_convert [ _ "Convert modules to another format. 
Please select catalogue with modules, output directory and press OK" ]
set help_fromchanges [ _ "Create module from system changes. Please edit /.savelist to add files and dirs.
You may append \"!\" at the begining of string to remove items from module. Then press \"enable save2module\"
Module will be ready after reboot" ]
set help_fromrepo [ _ "Use rpmdrake to create module. Please select output dir and press START" ]
set help_fromrpm [ _ "Create module from rpms. \
Please select file.rpm or enter package name from repo, than choose out directory and press OK. 
You can add args for urpmi after  rpm name. Default is  --auto --no-verify-rpm" ]
set help_fromdir [ _ "Compress directory to lzm/xzm module. Please choose input/output dirs and press OK" ]

  set datapath /mnt/live/etc/modules
  set path /mnt/livemedia/MagOS
  set test_exist [file exists $datapath]
    if {$test_exist == 0} {
    set path /mnt/livemedia/MagOS
    } else {
  set datapath_read [open $datapath r]
  seek $datapath_read 0 start
  set  datapath_string  [read $datapath_read]}
      if { [string match *MagOS-Data* $datapath_string] eq "1" }  {
      set path /mnt/livemedia/MagOS-Data
      } 
    
# каталоги по умолчанию
set filter "??-"
set indir_path /home/user
set outdir_path $path/optional
set infile /home/user/program.rpm
set mod_type "nolzm"
set lzmname ""


# получаем имя файла
proc getinfile {} {
  global infile indir_path
  set typelist {
    {"RPM package" {".rpm"}}
    }
  set infile [ tk_getOpenFile -parent . -initialdir $indir_path -filetypes  $typelist]
}

# получаем имя каталога для dir2lzm 
proc getindir {} {
  global indir_path
  set indir_path [ tk_chooseDirectory -initialdir $indir_path]
}

# получаем имя каталога в котором сохранить модуль
proc getoutdir {} {
  global outdir_path
  set outdir_path [ tk_chooseDirectory -initialdir /mnt/livemedia/MagOS/optional]
}

# терминальчик
proc term {} {
  global log
  toplevel .3
  wm title .3 [ _ "wait please" ]
  set log [text .3.log -height 15 -width 100]
  scrollbar .3.yscroll -orient vert
  .3.log conf -yscrollcommand {.3.yscroll set}
  .3.yscroll conf -command {.3.log yview}
  pack .3.yscroll -expand no -fill both -side right
  pack .3.log -expand yes -fill both -padx 1 -pady 1 
  update idletasks
  geometry .3
  grab .3
}

# выводим в терминальчик лог скриптов
proc Log {} {
  global input log lzmname outdir_path
    if [eof $input] {       
    $log insert end "#######################################################\n"
    $log insert end "################      The END     #####################\n"
    $log insert end "#######################################################\n"
    $log tag add blue "end - 4 lines"  end    
    $log tag configure blue -foreground blue  -justify center
    set err [$log search -nocase -regexp error|warning|ошиб|невозмож 1.0 end]
    if { $err ne "" } {
    $log tag add error "$err linestart" "$err lineend"
    $log tag configure error -foreground red
    $log tag configure blue -foreground red
    }
    $log insert end \n
    $log see end
catch {close $input}
catch {send mod_mnger full-update} 
    } else {
    gets $input line
    $log insert end $line\n
    $log see end
    }
}

# преобразование каталога в модуль
proc dir2lzm {} {
  global indir_path outdir_path log input lzmname
  set lzmname $outdir_path/[file tail $indir_path].xzm
  set command "/usr/lib/magos/scripts/dir2lzm $indir_path $lzmname"
  term
    if [catch {open "|$command |& cat"} input] {
    $log insert end $input\n
    } else {
    fileevent $input readable Log
    $log insert end $command\n
    }
}

# конвертирование
proc dir2mod {} {
  global indir_path  log input filter mod_type outdir_path
  set command "/usr/lib/magos/scripts/dir2mod $mod_type $indir_path $outdir_path $filter"
  term
    if [catch {open "|$command |& cat"} input] {
    $log insert end $input\n
    } else {
    fileevent $input readable Log
    $log insert end $command\n
    }
}

# процедура для urpm2lzm
proc urpm2lzm {} {
  global infile outdir_path log input
  set command "/usr/lib/magos/scripts/urpm2lzm  $infile --auto --no-verify-rpm "
  term
  cd $outdir_path 
    if [catch {open "|$command |& cat"} input] {
    $log insert end $input\n
    } else {
    fileevent $input readable Log
    $log insert end $command\n
    }
}

# запись в /.savelist
proc savelist {} {
global savelist_editor
set result [$savelist_editor get 1.0 end]
        set config $result
	set conf_file /.savelist
	set conf [open $conf_file w+]
	puts $conf $config
	close $conf
}	

# замена кнопки "активировать" на "деактивировать" и обратно
proc save2module_button {} {
  global status enable_button savename path
  set test [ lindex $status 0 ]
    if {$test == {disabled}} {
	if {$savename == "$path/modules/zz-save_date.xzm"} { set savename "" }
        exec /usr/lib/magos/scripts/save2module --enable $savename 
	savelist
	} else {
	exec /usr/lib/magos/scripts/save2module --disable
    }
  set status [ split [ exec /usr/lib/magos/scripts/save2module  ] ]
  set test [ lindex $status 0 ]
    if {$test == {disabled}} {	
    $enable_button configure -text  [ _ "Enable save2module" ]
    } else {
    $enable_button configure -text [ _ "Disable save2module"]	
    }
}

proc gethelp { arg } {
  global help_savelist_editor 
  ttk::frame .help 
  set help help_$arg
  eval set helptext $$help
  message .help.text -justify left -text  $helptext    -width 2000 
  pack .help .help.text -padx 1 -pady 1 -side left -fill both -expand yes
}

# меню шаблонов для savelist
proc patterns {} {
global savelist_editor 
  set patternfile /etc/savelist_patterns
  set test_cfg [file exists $patternfile]
    if {$test_cfg == 0} {
    set defaultpattern "\[save root home dir\]\n/root\n#You may edit /etc/savelist_patterns to add new pattern " 
    set conf [open $patternfile w+]
    puts $conf $defaultpattern
    close $conf
    }
  set conf [open $patternfile r]
  seek $conf 0 start
  set  patterns [read $conf]
  close $conf
  set patternlist [ split  [ string trimleft $patterns "\["] "\[" ]
    foreach item $patternlist {
    set a [ string trimright [ lindex [ split $item "\n" ] 0] "\]" ]
    lappend patternheaders $a
    }
  
catch {destroy .base.note.fromchanges.menu}
menu  .base.note.fromchanges.menu -tearoff 0 
    set incr 0  
    foreach item $patternheaders {
    set q [ string map { \[ # \] \ } [ lindex $patternlist $incr ] ]
    set com [list $savelist_editor insert 1.0 ##\ \ $q] 
    .base.note.fromchanges.menu add command -label $item -command $com    
    set incr [ expr $incr + 1 ]
  }
}

ttk::frame .logo 
image create photo logo -file /usr/share/icons/module-icon.gif
ttk::label .logo.logo -image logo 
label .logo.text -text [ _ "    Module creator" ] -fg blue  -font "Helvetica 12 bold" -bg [ lindex $bgcolors 1 ]  
pack .logo -anchor w -fill both -expand yes
pack .logo.logo .logo.text -side left 

ttk::frame .base 
pack .base -side top -expand yes -fill both
ttk::notebook .base.note
pack .base.note -fill both -expand 1 -padx 2 -pady 3
#ttk::notebook::enableTraversal .base.note


# рисуем вкладку "Модуль из каталога"
ttk::frame .base.note.fromdir
.base.note add .base.note.fromdir -text [ _ "Directory to module" ]  -padding 2
 
 ttk::frame .base.note.fromdir.help_fromdir
 pack .base.note.fromdir.help_fromdir   -fill x -expand yes
 ttk::label .base.note.fromdir.help_fromdir.message -text $help_fromdir
 pack .base.note.fromdir.help_fromdir.message  -fill x -expand yes 
  
  ttk::button .base.note.fromdir.indir -text [ _ "Choose directory =>" ] -command {getindir}
  ttk::entry .base.note.fromdir.indirlabel -textvariable indir_path 
  pack .base.note.fromdir.indir .base.note.fromdir.indirlabel  -padx 10 -pady 10 -side left -fill x -expand yes
  ttk::button .base.note.fromdir.outdir -text [ _ "Out directory =>" ]  -command {getoutdir}
  ttk::entry .base.note.fromdir.outdirlabel -textvariable outdir_path 
  pack .base.note.fromdir.outdir   .base.note.fromdir.outdirlabel -padx 10 -pady 10 -side left -fill x -expand yes
  set dir2lzm_ok [ttk::button .base.note.fromdir.ok -text [ _ "OK" ]   -command {dir2lzm}]
  pack .base.note.fromdir.ok -padx 10 -pady 10 -side right  
  

# Рисуем вкладку "Модуль из rpm"
ttk::frame .base.note.fromrpm
.base.note add .base.note.fromrpm -text [ _ "File.rpm to module" ] -padding 2
 
 ttk::frame .base.note.fromrpm.help_fromrpm
 pack .base.note.fromrpm.help_fromrpm  -fill x -expand yes
 ttk::label .base.note.fromrpm.help_fromrpm.message -text $help_fromrpm
 pack .base.note.fromrpm.help_fromrpm.message  -fill x -expand yes 
  
  ttk::button .base.note.fromrpm.infile -text [ _ "choose  file.rpm  =>" ]  -command {getinfile}
  ttk::entry .base.note.fromrpm.infilelabel -textvariable infile 
  pack .base.note.fromrpm.infile .base.note.fromrpm.infilelabel  -padx 10 -pady 10 -side left -fill x -expand yes
  ttk::button .base.note.fromrpm.outdir -text [ _ "Out directory =>" ]  -command {getoutdir}
  ttk::entry .base.note.fromrpm.outdirlabel -textvariable outdir_path 
  pack .base.note.fromrpm.outdir   .base.note.fromrpm.outdirlabel -padx 10 -pady 10 -side left -fill x -expand yes
  set urpm2lzm_ok [ttk::button .base.note.fromrpm.ok -text [ _ "OK" ]  -command {urpm2lzm}]
  pack .base.note.fromrpm.ok -padx 10 -pady 10 -side right


# Рисуем вкладку модуль из репозитория
ttk::frame .base.note.fromrepo
.base.note add .base.note.fromrepo -text [ _  "Module from repo" ]  -padding 2

 ttk::frame .base.note.fromrepo.help_fromrepo
 pack .base.note.fromrepo.help_fromrepo  -fill x -expand yes
 ttk::label .base.note.fromrepo.help_fromrepo.message -text $help_fromrepo
 pack .base.note.fromrepo.help_fromrepo.message  -fill x -expand yes 
 
  ttk::button .base.note.fromrepo.outdir -text [ _ "Out directory =>" ]  -command {getoutdir}
  ttk::entry .base.note.fromrepo.outdirlabel -textvariable outdir_path
  pack .base.note.fromrepo.outdir   .base.note.fromrepo.outdirlabel -padx 10 -pady 10 -side left -fill x -expand yes
    ttk::button .base.note.fromrepo.rpmdrake2lzm -text [ _ "start rpmdrake2lzm" ]  -command {
    cd $outdir_path
    catch { exec /usr/lib/magos/scripts/rpmdrake2lzm }
    }
  pack .base.note.fromrepo.rpmdrake2lzm -padx 10 -pady 10 -side right


# рисуем  "Модуль из изменений системы"
ttk::frame .base.note.fromchanges
.base.note add .base.note.fromchanges -text [ _ "Module from changes" ]  -padding 2

ttk::frame .base.note.fromchanges.help_fromchanges
 pack .base.note.fromchanges.help_fromchanges  -fill x -expand yes
 ttk::label .base.note.fromchanges.help_fromchanges.message -text $help_fromchanges
 pack .base.note.fromchanges.help_fromchanges.message  -fill x -expand yes 
  set conf_file /.savelist
  set test_cfg [file exists $conf_file]
    if {$test_cfg == 0} {
    set default "#You may specify files and dirs to save, for example:\n#/root\n#/etc\n#/*" 
    set conf [open $conf_file w+]
    puts $conf $default
    close $conf
    }
  set conf [open $conf_file r]
  seek $conf 0 start
  set  li [read $conf]

  ttk::button .base.note.fromchanges.adddir -text [ _ "Add directory" ]  -command {
    set adddir [ tk_chooseDirectory -initialdir /etc]
    $savelist_editor insert end "$adddir \n"}
  ttk::button .base.note.fromchanges.addfile -text [ _ "Add file" ]  -command {
    set addfile [ tk_getOpenFile -initialdir /etc]
    $savelist_editor insert end "$addfile \n"}
    set enable_button [ ttk::button .base.note.fromchanges.ok -text [ 
    set status [ split [ exec /usr/lib/magos/scripts/save2module  ] ]
    set test [ lindex $status 0 ]
    set savename [ lindex $status 1 ]
      if {$test == {disabled}} {	
      set a [ _ "Enable save2module" ]
      } else {
      set a [ _ "Disable save2module" ]	
      } 
   ]  -command {save2module_button} ]

ttk::menubutton  .base.note.fromchanges.savename -text "[ _ "module name:"] [file tail $savename]" -direction above -menu .base.note.fromchanges.savename.m 
    menu .base.note.fromchanges.savename.m -tearoff 0
      .base.note.fromchanges.savename.m add command -label "zz-save.xzm [ _ "(default)" ]" -command {
      set savename $path/modules/zz-save.xzm
      .base.note.fromchanges.savename configure -text "[ _ "module name:"] [file tail $savename]"
      }
	.base.note.fromchanges.savename.m add command -label "zz-save_date.xzm" -command {
	set savename $path/modules/zz-save_date.xzm
	.base.note.fromchanges.savename configure -text "[ _ "module name:"] [file tail $savename]"
	}
      .base.note.fromchanges.savename.m add command -label [ _ "enter new name"] -command {
      set savename [ tk_getSaveFile -parent .base.note.fromchanges -initialdir $path/modules ]
      .base.note.fromchanges.savename configure -text "[ _ "module name:"] [file tail $savename]"
      } 

  ttk::frame .base.note.fromchanges.top
  pack .base.note.fromchanges.top -side top -fill both -expand yes
  set savelist_editor [ text .base.note.fromchanges.top.textedit -height 3 -width 100 ] 
  ttk::scrollbar .base.note.fromchanges.top.yscroll -orient vert
  .base.note.fromchanges.top.textedit conf -yscrollcommand {.base.note.fromchanges.top.yscroll set}
  .base.note.fromchanges.top.yscroll conf -command {.base.note.fromchanges.top.textedit yview}
  pack .base.note.fromchanges.top.yscroll -expand no -fill both -side right
  pack .base.note.fromchanges.top.textedit -padx 1 -pady 1 -side top -fill both -expand yes
  pack .base.note.fromchanges.adddir .base.note.fromchanges.addfile  -padx 10 -pady 10 -side left
  pack   .base.note.fromchanges.ok .base.note.fromchanges.savename -padx 10 -pady 10 -side right
  $savelist_editor insert end $li
  bind  .base.note.fromchanges.top.textedit  <Button-1> { $savelist_editor configure -height 15 }  
  bind  .base <Leave> {$savelist_editor configure -height 3}
  bind $savelist_editor <Button-3> {
    patterns
    tk_popup .base.note.fromchanges.menu  %X %Y 
  } 

# рисуем вкадку конвертировать
ttk::frame .base.note.convert
.base.note add .base.note.convert -text [ _ "Convert modules" ] -padding 2
 
 ttk::frame .base.note.convert.help_convert
 pack .base.note.convert.help_convert  -fill x -expand yes
 ttk::label .base.note.convert.help_convert.message -text $help_convert
 pack .base.note.convert.help_convert.message  -fill x -expand yes 
  
    ttk::frame .base.note.convert.1 
    ttk::frame .base.note.convert.2 
    ttk::frame .base.note.convert.3 
    ttk::frame .base.note.convert.4 
    ttk::frame .base.note.convert.5 
    pack .base.note.convert.1 .base.note.convert.2 .base.note.convert.3 .base.note.convert.4 .base.note.convert.5 -side left -expand yes -fill x
  ttk::button .base.note.convert.1.indir -text [ _ "Choose directory =>" ]   -command {
  set indir_path /mnt/live/memory/images  
  getindir}
  ttk::entry .base.note.convert.1.indirlabel -textvariable indir_path 
  pack .base.note.convert.1.indir .base.note.convert.1.indirlabel  -padx 10 -pady 10 -side top -anchor w -fill x -expand yes
    ttk::button .base.note.convert.2.outdir -text [ _ "Out directory =>" ]  -command {getoutdir}
    ttk::entry .base.note.convert.2.outdirlabel -textvariable outdir_path 
    pack .base.note.convert.2.outdir   .base.note.convert.2.outdirlabel -padx 10 -pady 10 -side top -anchor w -fill x -expand yes
  ttk::label .base.note.convert.3.filter_label -text [ _ "Filter" ] 
  ttk::entry .base.note.convert.3.filter -textvariable filter 
  pack .base.note.convert.3.filter_label .base.note.convert.3.filter -padx 10 -pady 10 -side left
    ttk::radiobutton .base.note.convert.4.mod_type1 -variable mod_type -text [ _ "lzm" ] -value lzm  
    ttk::radiobutton .base.note.convert.4.mod_type2 -variable mod_type -text [ _ "xzm" ] -value xzm  
    ttk::radiobutton .base.note.convert.4.mod_type3 -variable mod_type -text [ _ "nocompress" ] -value nolzm 
    pack .base.note.convert.4.mod_type1 .base.note.convert.4.mod_type2 .base.note.convert.4.mod_type3  -padx 10 -pady 1 -side top -anchor w
  set convert_ok [ttk::button .base.note.convert.5.ok -text [ _ "OK" ]   -command {dir2mod}]    
  pack .base.note.convert.5.ok   -padx 10 -pady 10 -side right

update
proc geometry {win} {
set geometry [split [lindex [split [wm geometry $win ] "+"] 0] "x"]
set w [lindex $geometry end-1]
set n [lindex $geometry end]
set x [expr {([winfo screenwidth .]/2 - $w/2)}]
  if { $win eq "." } { 
  set y [expr {([winfo screenwidth .]/10)}]
  } else { 	
  set y [expr {([winfo screenheight .]/2 - $n/2)}]
  }
wm geometry $win +$x+$y
}
geometry .
wm resizable . 0 0
