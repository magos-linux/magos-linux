#!/usr/bin/python
# -*- coding:utf-8 -*-
import  gettext,  cgi, subprocess
import cfg, disks

gettext.install('install-helper', './locale', unicode=True)
dialog_text = 'none'

# messages for gettext
flag = _('flag').encode('UTF-8')
device = _('disk device').encode('UTF-8')
size = _('size').encode('UTF-8')
step1 = _('Step 1.').encode('UTF-8')
select_disk = _('Please select disk to format:').encode('UTF-8')
select_type = _('Please select partitions:').encode('UTF-8')
gparted = _('Use gparted').encode('UTF-8')
none= _('Nothing to do').encode('UTF-8')
title_type1= _('Standard fat32 or ntfs (if more then 4GB) flash drive for simple MagOS  installation.').encode('UTF-8')
title_type2= _('ext3 for MagOS installation, and fat32 or ntfs (if more then 4GB) for data. MagOS will invisible from windows').encode('UTF-8')
title_type3= _('Recomended partitions for install MagOS in hdd').encode('UTF-8')
update_= _('Update').encode('UTF-8')
next_= _('Next...').encode('UTF-8')
submit_= _('Format').encode('UTF-8')
gparted_start = _('Start gparted').encode('UTF-8')

#гуглоперевод надо править, сделал чтоб посмотреть как выглядит
#if_you = _('If  you need  another partitions, you may  ').encode('UTF-8')
#step1_help = _(' Preparing disks  for installation Magos. If your drive is already formatted, you can skip this step. If formatting is necessary  select the drive in the left   table and the method of formating in the right, then click "Format". Be especially careful. Full information under "Help" button.  ').encode('UTF-8')

# временные русские тексты 
if_you = 'Если предложенные варианты не подходят, вы можете... '
step1_help = 'Подготовка диска к установке МагОС. Если ваши диски уже форматированы как нужно вы можете пропустить этот шаг. Если разбивка диска всеже нужна выберите диск в левой таблице и  как разбить в правой. После нажмите кнопку форматировать. Будте особенно осторожны, эти действия уничтожат все данные на выбранном диске. Подробная информация под кнопкой ПОМОЩЬ. '

help_=('Help!').encode('UTF-8')
not_mouted = _('is not mounted').encode('UTF-8')

def formating(disk, format_type):
		dialog_text='format - partitions create - OK!!!'
		command = ('beesu  xterm -e ./parted.sh  ' + disk + ' ' + format_type + '')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = ('<br>sorry formating -  FAIL!!!, code:' + ret)
		return dialog_text

def gparted_exec():
	command = ('gparted')
	subprocess.Popen(command, shell=True)
	dialog_text = 'Update after gparted'
	return dialog_text

form = cgi.FieldStorage()
gparted = form.getvalue('gparted') or  'none' 
disk = form.getvalue('physical') or 'none'
format_type = form.getvalue('format-type') or 'none'
 
if gparted == 'start':
	gparted_exec()
	
if gparted == 'none' and disk != 'none' and format_type != 'none':
	result=formating(disk, format_type) 

physical = disks.getPhysical()
logical =  disks.getLogical()
 
# make header
cfg.html_header()

print """<style>
#fat32_400 {
    width: 400px;
    height: 30px;
    background: #04E31A;
}

#fat32_250 {
	float: left;
    width: 250px;
    height: 30px;
    background: #04E31A;
}

#ext3_150 { 
	float: left;
    width: 150px;
    height: 30px;
    background: #7BCDE3;
}

#ext2_100 {
   float: left; 
    width: 100px;
    height: 30px;
    background: #DCDCDC;
}

#ext3_260 {
    float: left; 
    width: 260px;
    height: 30px;
    background: #7BCDE3;
}

#swap40 {
	float: left;
    width: 40px;
    height: 30px;
    background: #FF1111;
}
</style>

<script type="text/javascript">
$(function(){
	$("input:text, input:submit").button();
	$("div.set").buttonset();
});

$(window).load(function() {
    var iframe = $('#mainframe', parent.document.body);
	iframe.height($(document).outerHeight(true) ); 
});

$(function(){
	$("#dialog").dialog();
	});
</script>	
"""

if dialog_text != 'none':
	print '<div id="dialog" title="' + action + '">'
	print dialog_text + '</div>'



print '<h1>' + step1 + '</h1><p>' + step1_help + '</p>'
print '''
<div class="set"><table id="top" width="320"> <tr><td>
<form action="/cgi-bin/firststap.py">'''
print ' <button type="submit">' + update_ + '</button></form>'
print '''
</td><td>
<form action="/cgi-bin/secondstap.py">'''
print '<button type="submit">' + next_ + '</button> </form>'
print '</td><td>'
print '<form action="/cgi-bin/install_help.py"><button type="submit">' + help_ + '</button></form>'
print '</td></tr></table></div>'

print '<table id="main_table" >'
print '<tr><td valign="top">'
print '<h2>' + select_disk + '</h2>'  
print '<form action="/cgi-bin/firststap.py" method="post" name=ds_form>'	
print '<table  id="disk-table" border="1" width="400">'
print '<tr><td align="center">' + flag + '</td><td align="center">' +  device +  '</td><td align="center">' + size + '</td> </tr>'
for key, val in physical.items():
	print '<tr><td rowspan="2"><input type="radio"    name="physical"  value="' + key + '"></td><td><b>' + key + '</b></td><td> ' + val[0]  + ' ' + val[1] + '</td></tr>'
	print '<tr><td colspan="2">'
	for key1, val1 in logical.items():
			if key1[:-1] == key:
				print '<i>' + key1 + ':</i>  ' + val1[0][0] + ';   ' + val1[0][1]  
				print '<div title="dirList:             '
				for f in val1[1]: 	
					print f + ', '
				print '">mount: '  
				if val1[0][6] != '/dev': 
					print  val1[0][6]
				else: 
					print  not_mouted
				print  '</div><br>'
	print '</td></tr>'
print '</table></td><td  valign="top">'

print '<h2>' + select_type + '</h2>' 
print '<table  id="type-table" border="1">'
print '<tr align="center" title="' + title_type1 + '"><td ><input type="radio"    name="format-type"  value="type1"></td><td><div id="fat32_400">fat-32 / ntfs</div></td></tr>'
print '<tr align="center" title="' + title_type2 + '"><td><input type="radio"    name="format-type"  value="type2"></td><td><div id="fat32_250">fat-32 / ntfs</div><div id="ext3_150">ext 3</div></td></tr>'
print '<tr align="center" title="' + title_type3 + '"><td><input type="radio"    name="format-type"  value="type3"></td><td><div id="ext2_100">ext 2</div><div id="swap40">swap</div><div id="ext3_260">ext 3</div></td></tr></table>'
print '</td></tr></table>' 
print '<input type="submit"  name="submit"    value="' + submit_ +'">'
print '</form>'


print '<br>' + if_you
print '<form action="/cgi-bin/firstatap.py">'
print '<input type="hidden" value="start" name="gparted">'

print '<div class="set"><button type="submit">' + gparted_start + '</button><div></form>'

print '</body></html>'
