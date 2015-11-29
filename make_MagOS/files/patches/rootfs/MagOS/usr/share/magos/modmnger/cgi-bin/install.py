#!/usr/bin/python
# -*- coding:utf-8 -*-
import  gettext,  cgi, cfg

gettext.install('install-helper', './locale', unicode=True)
dialog_text = 'none'


# messages for gettext
install_header  = _('MagOS linux install helper').encode('UTF-8')
install_help = _('This is a simple MagOS linux installator. You must select automatic or step by step mode. ').encode('UTF-8')
autoinstall_link = _('Automatic installation').encode('UTF-8')
stepbystep_link = _('Step by step  installation').encode('UTF-8')
help_= _('Help!').encode('UTF-8')
update_link= _('Update MagOS').encode('UTF-8')

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
</script>	
"""

print '<h1>' + install_header + '</h1><p>' + install_help + '</p><br>'
print '<br>'
print '<div class="set"><form action="/cgi-bin/install_help.py" method="post"  name="help">'
print '<input type="hidden" name="back" value="/cgi-bin/install.py">'
print '<button type="submit">' + help_ + '</button></form></div>'
print '<table>'
print '<tr><td class="redbutton"><div class="set"><form action="/cgi-bin/autoinstall.py">'
print ' <button type="submit">' + autoinstall_link + '</button></form></div></td></tr>'
print '<tr><td class="greenbutton"><div class="set"><form action="/cgi-bin/firststep.py">'
print ' <button type="submit">' + stepbystep_link + '</button></form></div></td></tr>'
print '<tr><td class="bluebutton"><div class="set"><form action="/cgi-bin/update.py">'
print ' <button type="submit">' + update_link + '</button></form></div></td></tr>'
print '</table>'
print '</body></html>'

