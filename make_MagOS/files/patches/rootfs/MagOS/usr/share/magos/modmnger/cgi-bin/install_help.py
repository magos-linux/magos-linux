#!/usr/bin/python
# -*- coding:utf-8 -*-
import  gettext, cfg, cgi, os

gettext.install('install-helper', './locale', unicode=True)
dialog_text = 'none'

# messages for gettext
back_ = _('back...').encode('UTF-8')

form = cgi.FieldStorage()
back = form.getvalue('back') or  'index.py' 

locale_help='./' + os.getenv('LANG')[:5] + '/help.include'

# make html header
cfg.html_header()
cfg.hide_div()
print '<link type="text/css" href="/css/install-helper.css"   rel="stylesheet" />'

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
</script>"""	



print '<div class="set"><form action="' + back + '" method="post"  name="help">'
print '<button type="submit">' + back_ + '</button></form></div>'

try:
		f = open( locale_help,  'r')
		text = ''
		for string  in f.readlines():
			text = text + string
		print text.replace('\n\n', '\n')
		f.close()
except: 
		print  """
		English help text must be here, but it is not ready :(
		"""
		
print '</body></html>'
