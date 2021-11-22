#!/bin/bash
PFP=/etc/xdg/plasmarc
[ -f $PFP ] || exit 0

patch -p1 -d /usr/share/plasma/wallpapers/org.kde.image/contents/config <<EOF
--- a/main.xml	2021-08-31 14:52:18.000000000 +0300
+++ b/main.xml	2021-11-16 10:32:05.000000000 +0300
@@ -16,7 +16,7 @@
     </entry>
     <entry name="Image" type="String">
       <label>Wallpaper image path or wallpaper name</label>
-      <default></default>
+      <default>file:///usr/share/magos/wallpapers/default.jpg</default>
     </entry>
     <entry name="FillMode" type="int">
       <label>Sizing, cropping and positioning of the wallpaper image</label>
EOF

patch -p1 -d /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents <<EOF
diff -aupr a/layout.js b/layout.js
--- a/layout.js	2021-11-16 20:21:05.318931059 +0300
+++ b/layout.js	2021-11-16 20:15:03.000000000 +0300
@@ -25,7 +25,7 @@ if (freeEdges["bottom"] == true) {
     panel.location = "top";
 }
 
-panel.height = gridUnit * 2.5
+panel.height = gridUnit * 2
 
 // Restrict horizontal panel to a maximum size of a 21:9 monitor
 const maximumAspectRatio = 21/9;
@@ -43,24 +43,42 @@ if (panel.formFactor === "horizontal") {
 var kickoff = panel.addWidget("org.kde.plasma.kickoff")
 kickoff.currentConfigGroup = ["Shortcuts"]
 kickoff.writeConfig("global", "Alt+F1")
+kickoff.writeConfig("icon", "/usr/share/icons/magos.svg")
 
 var dolphin = panel.addWidget("org.kde.plasma.icon")
+dolphin.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.dolphin.desktop")
 dolphin.currentConfigGroup = ["General"]
 dolphin.writeConfig("applicationName", "Dolphin")
 dolphin.writeConfig("iconName", "system-file-manager")
 dolphin.writeConfig("url","file:///usr/share/applications/kde5/org.kde.dolphin.desktop")
 
 var firefox = panel.addWidget("org.kde.plasma.icon")
+firefox.writeConfig("localPath", "/usr/share/applications/firefox.desktop")
 firefox.currentConfigGroup = ["General"]
-firefox.writeConfig("applicationName", "Chromium")
-firefox.writeConfig("iconName", "chromium-browser")
-firefox.writeConfig("url","file:///usr/share/applications/chromium-browser.desktop")
-
-var libreoffice = panel.addWidget("org.kde.plasma.icon")
-libreoffice.currentConfigGroup = ["General"]
-libreoffice.writeConfig("applicationName", "Elisa")
-libreoffice.writeConfig("iconName", "elisa")
-libreoffice.writeConfig("url","file:///usr/share/applications/kde5/org.kde.elisa.desktop")
+firefox.writeConfig("applicationName", "Firefox")
+firefox.writeConfig("iconName", "firefox")
+firefox.writeConfig("url","file:///usr/share/applications/firefox.desktop")
+
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
 
 //panel.addWidget("org.kde.plasma.showActivityManager")
 panel.addWidget("org.kde.plasma.pager")
EOF

[ -h /usr/share/plasma/avatars ] && exit 0

if [ -d /usr/share/plasma/avatars -a -d /usr/share/icons/gnome/48x48/emotes ] ;then
   rm -fr /usr/share/plasma/avatars
   ln -sf /usr/share/icons/gnome/48x48/emotes /usr/share/plasma/avatars
fi

exit 0
