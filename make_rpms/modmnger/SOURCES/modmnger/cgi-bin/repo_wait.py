#!/usr/bin/python
# -*- coding:utf-8 -*-
import  cfg, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# этот файл нужен, чтоб не показывать пустую страницу во время чтения с фтп

cfg.html_header()
cfg.hide_div()

print """
<script type="text/javascript">
$('#loader').show();
$('#body').hide();
$('#loader').animate({opacity:0}, 3000);
$('#loader').animate({opacity:1}, 1000);
var deltime = setInterval('flash()', 5000)
window.location='/cgi-bin/repo.py'
</script>
</div>
</body>
</html>"""
