#!/bin/bash

[ -x /usr/bin/startmate ] || exit 0

PFP=/usr/share/applications/screensavers/personal-slideshow.desktop
sed -i s%^Exec=.*%"Exec=/usr/lib64/mate-screensaver/slideshow --location=/usr/share/magos/screensaver/Default"% $PFP
ln -sf /usr/share/magos/wallpapers/Default /usr/share/backgrounds/mate

patch -d /usr/share/glib-2.0/schemas -p1 <<EOF
diff -aupr a/org.mate.interface.gschema.xml b/org.mate.interface.gschema.xml
--- a/org.mate.interface.gschema.xml	2018-12-27 11:49:28.000000000 +0300
+++ b/org.mate.interface.gschema.xml	2020-04-20 11:16:37.506904294 +0300
@@ -56,12 +56,12 @@
       <description>Length of the cursor blink cycle, in milliseconds.</description>
     </key>
     <key name="icon-theme" type="s">
-      <default>'neru-mate-blue-light'</default>
+      <default>'Default'</default>
       <summary>Icon Theme</summary>
       <description>Icon theme to use for the panel, Caja etc.</description>
     </key>
     <key name="gtk-theme" type="s">
-      <default>'Neru-canta-blue-light'</default>
+      <default>'Default'</default>
       <summary>Gtk+ Theme</summary>
       <description>Basename of the default theme used by gtk+.</description>
     </key>
@@ -71,7 +71,7 @@
       <description>Basename of the default theme used by gtk+.</description>
     </key>
     <key name="gtk-color-scheme" type="s">
-      <default>'Neru-canta-blue-light'</default>
+      <default>'Default'</default>
       <summary>List of symbolic names and color equivalents</summary>
       <description>A '\n' separated list of "name:color" as defined by the 'gtk-color-scheme' setting</description>
     </key>
diff -aup a/org.mate.screensaver.gschema.xml b/org.mate.screensaver.gschema.xml
--- a/org.mate.screensaver.gschema.xml	2019-02-08 17:55:00.000000000 +0300
+++ b/org.mate.screensaver.gschema.xml	2020-04-17 09:47:29.546572114 +0300
@@ -6,22 +6,22 @@
   </enum>
   <schema id="org.mate.screensaver" path="/org/mate/screensaver/">
     <key name="idle-activation-enabled" type="b">
-      <default>false</default>
+      <default>true</default>
       <summary>Activate when idle</summary>
       <description>Set this to TRUE to activate the screensaver when the session is idle.</description>
     </key>
     <key name="lock-enabled" type="b">
-      <default>true</default>
+      <default>false</default>
       <summary>Lock on activation</summary>
       <description>Set this to TRUE to lock the screen when the screensaver goes active.</description>
     </key>
     <key name="mode" enum="org.mate.screensaver.Mode">
-      <default>'blank-only'</default>
+      <default>'single'</default>
       <summary>Screensaver theme selection mode</summary>
       <description>The selection mode used by screensaver. May be "blank-only" to enable the screensaver without using any theme on activation, "single" to enable screensaver using only one theme on activation (specified in "themes" key), and "random" to enable the screensaver using a random theme on activation.</description>
     </key>
     <key name="themes" type="as">
-      <default>[]</default>
+      <default>['screensavers-personal-slideshow']</default>
       <summary>Screensaver themes</summary>
       <description>This key specifies the list of themes to be used by the screensaver. It's ignored when "mode" key is "blank-only", should provide the theme name when "mode" is "single", and should provide a list of themes when "mode" is "random".</description>
     </key>
EOF

/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas

exit 0
