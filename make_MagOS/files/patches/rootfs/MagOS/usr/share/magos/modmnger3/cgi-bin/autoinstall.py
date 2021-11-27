#!/usr/bin/python3
# -*- coding:utf-8 -*-
import  gettext,  cgi, subprocess
import cfg, disks

gettext.install('install-helper', localedir='./locale', codeset=None, names=None)
dialog_text = 'none'

# messages for gettext
flag = _('flag')
device = _('disk device')
size = _('size')
select_disk = _('Please select disk to install MagOS:')
none= _('Nothing to do')
update_= _('Update')
submit_= _('Install MagOS')
not_mouted = _('is not mounted')
autoinstall_header = _('Auto install MagOS linux')
autoinstall_help = _('Select disk and push INSTALL button to start installation. Be especially careful, you loose all data in selected disk. ')
help_= _('Help!')
prev_ = _('Prev...')
install_OK =  _('install MagOS - OK!!!')
install_fail = _('Sorry, install MagOS - FAIL!!!')
action =_('MagOS instalation')
	
form = cgi.FieldStorage()
disk = form.getvalue('physical') or 'none'

if disk != 'none':
	dialog_text=install(disk) 

# make header
cfg.html_header()
print('<link type="text/css" href="/css/install-helper.css"   rel="stylesheet" />')
print('<h1>' + autoinstall_header + '</h1><p>' + autoinstall_help + '</p>')
print('''
<div class="set"><table class="top" width="500"> <tr><td>
<form action="/cgi-bin/autoinstall.py">''')
print(' <button type="submit">' + update_ + '</button></form>')
print('</td><td>')
print('<td><form action="/cgi-bin/install.py"><button type="submit">' + prev_ + '</button></form></td>')
print('<td><form action="/cgi-bin/install_help.py#autoinstall" method="post">')
print('<input type="hidden" name="back" value="/cgi-bin/autoinstall.py">')
print('<button type="submit">' + help_ + '</button></form></div>')
print('</td></tr></table></div>')

print('<h2>' + select_disk + '</h2>')  
print('<form action="/cgi-bin/autoinstall.py" method="post" name=ds_form>')	
print('<table  class="bordered-table">')
print('<tr><td class="bordered_td">' + flag + '</td><td class="bordered_td">' +  device +  '</td><td class="bordered_td">' + size + '</td> </tr>')

print('<div id="disksDiv" name="disksDiv"')
print('<tr><td colspan="3"><h2>Диски.</h2></td></tr></div>')

print('</table>')
 
print('<input type="submit"  name="submit"    value="' + submit_ +'">')
print('</form>')
print('</body></html>')

