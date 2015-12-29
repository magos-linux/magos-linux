#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, cgi, subprocess, urllib, cfg, gettext
gettext.install('mod_mnger', './locale', unicode=True)

#messages for gettext
title = _('search form to find magos modules').encode('UTF-8')  
find1 = _('What are you find?').encode('UTF-8') 
find1_about = _('program name, module name or regexp ').encode('UTF-8') 
find2 = _('in text on web page').encode('UTF-8') 
location = _('web resources').encode('UTF-8') 
repos = _('repositories').encode('UTF-8') 
mirrors = _('repositories, mirrors, user\'s modules').encode('UTF-8') 
web = _('all web').encode('UTF-8') 
submit = _('submit').encode('UTF-8') 

form = cgi.FieldStorage() 
anchor = form.getvalue('anchor') or 'none' 
intext = form.getvalue('intext') or 'none'
area = form.getvalue('area') or 'repo'

uri = 'http://www.google.ru/search?q=inurl%3Amagos'
if anchor == intext == 'none':
	uri = 'none'
else:
	  anchor = urllib.quote(anchor)
	  if anchor != 'none':
		uri = (uri + '+inanchor%3A' + anchor )

	  if area == 'repo':
		uri = (uri + '+site%3Amagos.sibsau.ru+OR+site%3Amirror.yandex.ru')
	  elif area == 'larets':
		uri = (uri + '+site%3Amagos.sibsau.ru+OR+site%3Amirror.yandex.ru+OR+site%3Afiles.magos-linux.ru')
	  
	  if intext != 'none':
		intext = urllib.quote(intext)
		uri = (uri + '+' + intext)
	 	
	
# make html header
cfg.html_header()

if uri != 'none':
		command = ('firefox -new-tab' + '  ' + '"' + uri + '"' + '  &') 
		subprocess.call(command, shell=True)

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
	var availableTags = ["flashplayer", "opera", "skype", "add-graphics", "add-internet", "add-editors",
			"add-music", "add-inernet"];
	$("#input1").autocomplete({
		source: availableTags
	});
});
</script>	
<table class="s_table" align="left" width="100%"  
"""
print 'title="' + title + '">'
print '<tr><td><form action="/cgi-bin/search.py" method="post">'
print '<p><strong>' + find1 + '</strong></p>'
print '<p>' + find1_about + '</p>'
print '<input name="anchor" type="text" id="input1" size="60"><br>'
print '<p><strong>' + find2 + '</strong></p>'
print '<input name="intext" type="text" id="input2" size="60"><br>'
print '<p><strong>' + location + '</strong></p>'
print '<div class="set">'
print '<input name="area" id="area1" type="radio" value="repo" checked><label for="area1">' + repos + '</label>'
print '<input name="area" id="area2" type="radio" value="larets"><label for="area2">' + mirrors + '</label>'
print '<input name="area" id="area3" type="radio" value="inet" ><label for="area3">' + web + '</label>'
print '</div>'
print '<p><input type="submit" value="' + submit + '"></p>'
print '</form></td></tr></table>'
print '</body></html>'

