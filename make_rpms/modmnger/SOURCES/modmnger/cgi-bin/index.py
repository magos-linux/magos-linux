#!/usr/bin/python
# -*- coding:utf-8 -*-
import cfg, gettext, lib_mod_map

plugins = lib_mod_map.getPlugins('./plugins')

#header
cfg.html_header()
print """
<style type="text/css">
	p{font-size:0.7em;}
</style>

<script type="text/javascript">
$(document).ready(function() {
   $("#accordion").accordion({
    event: "click",
    navigation: "true",
    collapsible: "true"	
   });
});

function select(src) {
   document.getElementById("mainframe").src=(src)
	};
</script>

<table id=basetable>
<tr><td height="100" align="center" ><img src="/logo.png"  alt="MagOS"></td>
<td rowspan="2" width="80%" height="100%"> <iframe frameborder="no" scrolling="no" 
id="mainframe" name="mainframe" width="100%"  height="600px" src=" """
print plugins[0]['url']
print """ 
"></iframe></td></tr>
<tr><td width="20%" valign="top">
'<div id="accordion">' """

for plugin in plugins:
	gettext.install( plugin['i18n'], './locale', unicode=True)
	print '<h2><a href="#head1"> %s </a></h2>' % _(plugin['name']).encode('UTF-8') 
	print '<div id="head1" onclick=\'select("%s")\'><p>%s</p></div>' % (plugin['url'], _(plugin['action_name']).encode('UTF-8')) 

print '</td><td></td></tr></table></body></html>'

 
