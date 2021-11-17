#!/bin/bash
PFP=/etc/xdg/plasmarc
[ -f $PFP ] || exit 0

patch -p1 <<EOF
--- /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js.orig	2018-01-18 06:25:07.000000000 +0300
+++ /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js	2017-12-31 22:12:30.950196149 +0300
@@ -36,23 +36,42 @@ minimizeall.currentConfigGroup = ["Short
 minimizeall.writeConfig("global", "Meta+M")
 
 var dolphin = panel.addWidget("org.kde.plasma.icon")
+dolphin.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.dolphin.desktop")
 dolphin.currentConfigGroup = ["General"]
 dolphin.writeConfig("applicationName", "Dolphin")
 dolphin.writeConfig("iconName", "system-file-manager")
 dolphin.writeConfig("url","file:///usr/share/applications/kde5/org.kde.dolphin.desktop")
 
-var libreoffice = panel.addWidget("org.kde.plasma.icon")
-libreoffice.currentConfigGroup = ["General"]
-libreoffice.writeConfig("applicationName", "LibreOffice Writer")
-libreoffice.writeConfig("iconName", "libreoffice-writer")
-libreoffice.writeConfig("url","file:///usr/share/applications/libreoffice-writer.desktop")
-
 var firefox = panel.addWidget("org.kde.plasma.icon")
+firefox.writeConfig("localPath", "/usr/share/applications/firefox.desktop")
 firefox.currentConfigGroup = ["General"]
 firefox.writeConfig("applicationName", "Firefox")
 firefox.writeConfig("iconName", "firefox")
 firefox.writeConfig("url","file:///usr/share/applications/firefox.desktop")
 
+var thunderbird = panel.addWidget("org.kde.plasma.icon")
+thunderbird.writeConfig("localPath", "/usr/share/applications/thunderbird.desktop")
+thunderbird.currentConfigGroup = ["General"]
+thunderbird.writeConfig("applicationName", "Thunderbird")
+thunderbird.writeConfig("iconName", "mozilla-thunderbird")
+thunderbird.writeConfig("url","file:///usr/share/applications/thunderbird.desktop")
+
+var doublecmd = panel.addWidget("org.kde.plasma.icon")
+doublecmd.writeConfig("localPath", "/usr/share/applications/doublecmd.desktop")
+doublecmd.currentConfigGroup = ["General"]
+doublecmd.writeConfig("applicationName", "Double Commander")
+doublecmd.writeConfig("iconName", "doublecmd")
+doublecmd.writeConfig("url","file:///usr/share/applications/doublecmd.desktop")
+
+var kalc = panel.addWidget("org.kde.plasma.icon")
+kalc.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.kcalc.desktop")
+kalc.currentConfigGroup = ["General"]
+kalc.writeConfig("applicationName", "Kalc")
+kalc.writeConfig("iconName", "accessories-calculator")
+kalc.writeConfig("url","file:///usr/share/applications/kde5/org.kde.kcalc.desktop")
+
+panel.addWidget("org.kde.plasma.pager")
+
 var taskmanager = panel.addWidget("org.kde.plasma.taskmanager")
 taskmanager.currentConfigGroup = ["General"]
 taskmanager.writeConfig("groupingStrategy", "0")
EOF

patch -p1 <<EOF
--- /usr/share/plasma/wallpapers/org.kde.image/contents/config/main.xml.orig	2018-01-02 16:12:27.000000000 +0300
+++ /usr/share/plasma/wallpapers/org.kde.image/contents/config/main.xml	2018-01-01 12:28:36.596399354 +0300
@@ -12,7 +12,7 @@
     </entry>
     <entry name="Image" type="String">
       <label>Wallpaper image path or wallpaper name</label>
-      <default></default>
+      <default>file:///usr/share/magos/wallpapers/default.jpg</default>
     </entry>
     <entry name="FillMode" type="int">
       <label>Sizing, cropping and positioning of the wallpaper image</label>
EOF
