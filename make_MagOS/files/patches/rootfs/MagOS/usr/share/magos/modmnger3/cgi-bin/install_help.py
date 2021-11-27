#!/usr/bin/python3
# -*- coding:utf-8 -*-
import  gettext, cfg, cgi, os

gettext.install('install-helper', localedir='./locale', codeset=None, names=None)
dialog_text = 'none'

# messages for gettext
back_ = _('back...')

form = cgi.FieldStorage()
back = form.getvalue('back') or  'index.py' 

locale_help='./' + os.getenv('LANG')[:5] + '/help.include'

# make html header
cfg.html_header()
print('<link type="text/css" href="/css/install-helper.css"   rel="stylesheet" />')
print('<div class="set"><form action="' + back + '" method="post"  name="help">')
print('<button type="submit">' + back_ + '</button></form></div>')

try:
		f = open( locale_help,  'r')
		text = ''
		for string  in f.readlines():
			text = text + string
		print(text.replace('\n\n', '\n'))
		f.close()
except: 
		print("""
		English help text must be here, but it is not ready :(
		""")
		
print('</body></html>')
