#!/usr/bin/python
# -*- coding:utf-8 -*-

import gettext,  cgi, subprocess
import cfg, disks
gettext.install('install-helper', './locale', unicode=True)

# file system filters for boot and MagOS dirs
boot_filter=('vfat', 'ntfs', 'ext3', 'linux-native', 'ext2')
magos_filter=('vfat', 'ntfs', 'ext3', 'linux-native', 'ext2')

dialog_text = 'none'

# messages for gettext
step2 =  _('Step 2.').encode('UTF-8')
update_ = _('Update').encode('UTF-8')
next_ = _('Next...').encode('UTF-8')
submit_ =_('Copy MagOS files to destination disks').encode('UTF-8')
prev_ = _('Prev...').encode('UTF-8')
magos_header = _('Please select disk to MagOS dir').encode('UTF-8')
magos_data_header = _('Please select disk to MagOS-Data dir').encode('UTF-8')
boot_header = _('Please select disk to boot dir').encode('UTF-8')
flag = _('flag').encode('UTF-8')
device = _('device').encode('UTF-8')
size = _('size').encode('UTF-8')
free_size = _('free size').encode('UTF-8')
mount_point = _('mount point').encode('UTF-8')
not_mounted = _('is not mounted yet').encode('UTF-8')
submit_2= _('Copy MagOS linux catalogues to disks').encode('UTF-8')
# Ангийский надо править
#step2_help=_('Selecting disks for  MagOS linux dirs. Catalogues MagOS, MagOS-Data and boot can be located on the same or on different media. Folder MagOS-Data is not required such in MagOS.iso it is not. Directory boot can also be excluded if you use a different boot loader. MagOS catalog contains the main files. MagOS need it anyway.').encode('UTF-8')
step2_help  ='Выбор дисков для каталогов МагОС. Папки MagOS, MagOS-Data и boot могут быть расположены как на одном так и на разных дисках. Каталог MagOS-Data не является обязательным, например в iso сборках его нет. Каталог boot также может быть исключен, если вы используете другой загрузчик. Папка MagOS содержит основные файлы, она нужна всегда.'

help_=('Help!').encode('UTF-8')


def magos_install ():
		dialog_text = ('OK')
		command = ('beesu  xterm -e ./magos-install.sh  -m ' + magos + ' -d ' + magos_data   + ' -b  ' + boot  + ' ' )
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = ('<br>sorry magos install -  FAIL!!!? code:' + ret)
		return dialog_text
		
form = cgi.FieldStorage()
magos = form.getvalue('magos') or  'none' 
boot = form.getvalue('boot') or 'none'
magos_data = form.getvalue('magos-data') or 'none'
 
	
if magos != 'none' or boot != 'none' or magos_data != 'none':
	result=magos_install() 

#physical = disks.getPhysical()
logical = disks.getLogical()

# make html header
cfg.html_header()


print """
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

print '<h1>' + step2 + '</h1><p>' + step2_help + '</p>'
print '<div class="set"><table id="top" width="400"> <tr><td>'
print '<form action="/cgi-bin/secondstap.py">'
print ' <button type="submit">' + update_ + '</button></form>'
print '</td><td>'
print '<form action="/cgi-bin/firststap.py"><button type="submit">' + prev_ + '</button></form>'
print '</td><td>'
print '<form action="/cgi-bin/thirdstap.py"><button type="submit">' + next_ + '</button> </form>'
print '</td><td>'
print '<form action="/cgi-bin/install_help.py"><button type="submit">' + help_ + '</button></form>'
print '</td></tr></table></div>'

print '<form action="/cgi-bin/secondstap.py" method="post" name=copy_form>'
print '<h3>' + magos_header + '</h3>'

	
print '<table  id="magos-table" border="1" width="100%">'
print '<tr><td align="center">' + flag + '</td><td align="center">' +  device +  '</td><td align="center">' + size + '</td>' 
print '<td align="center">' + free_size + '<td align="center">' + mount_point + '</td></td> </tr>'

for key, val in logical.items():
	if val[0][1] in magos_filter != '0':
		print  '<tr  title="dirList: '
		for f in val[1]: 	
			print f + ' '
		print '">'	
		print  '<td><input type="radio" name=magos id="' + key.replace('/', '-') + '" value="' + key + '"'
		if  val[0][0] == 'magos':
			print ' checked '
		print  '></td>'
		print '<td>' + key + '</td><td>' + val[0][2] + '</td><td>' + val[0][4] + '</td><td>' 
		if val[0][6] != '/dev': 
			print  val[0][6]
		else: 
			print  not_mounted
			
		print '</td></tr>'

print '</table>'
print '<h3>' + magos_data_header + '</h3>'
print '<table  id="magos-data-table" border="1" width="100%">'
print '<tr><td align="center">' + flag + '</td><td align="center">' +  device +  '</td><td align="center">' + size + '</td>' 
print '<td align="center">' + free_size + '<td align="center">' + mount_point + '</td></td> </tr>'

for key, val in logical.items():
	if val[0][1] != 'swap':
		print  '<tr  title="dirList: '
		for f in val[1]: 	
			print f + ' '
		print '">'	
		print  '<td><input type="radio" name="magos-data" id="' + key.replace('/', '-') + '" value="' + key + '"'
		if  val[0][0] == 'magos-data':
			print ' checked '
		print '></td>'
		print '<td>' + key + '</td><td>' + val[0][2] + '</td><td>' + val[0][4] + '</td><td>' 
		if val[0][6] != '/dev': 
			print  val[0][6]
		else: 
			print  not_mounted
			
		print '</td></tr>'

print '</table>'

print '<h3>' + boot_header + '</h3>'
print '<table  id="boot-table" border="1" width="100%">'
print '<tr><td align="center">' + flag + '</td><td align="center">' +  device +  '</td><td align="center">' + size + '</td>' 
print '<td align="center">' + free_size + '<td align="center">' + mount_point + '</td></td> </tr>'

for key, val in logical.items():
	if val[0][1] in boot_filter != '0':
		print  '<tr  title="dirList: '
		for f in val[1]: 	
			print f + ' '
		print '">'	
		print  '<td><input type="radio" name="boot" id="' + key.replace('/', '-') + '" value="' + key + '"'
		if  val[0][0] == 'magos':
			print ' checked '
		print '></td>'
		print '<td>' + key + '</td><td>' + val[0][2] + '</td><td>' + val[0][4] + '</td><td>' 
		if val[0][6] != '/dev': 
			print  val[0][6]
		else: 
			print  not_mounted
			
		print '</td></tr>'
print '</table>'
print '<br><br>'
print '<input type="submit"  name="submit"    value="' + submit_2 + '"></form>'
print '</body></html>'


