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

PFP=/usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js
cat >$PFP <<EOF
var panel = new Panel
var panelScreen = panel.screen
var freeEdges = {"bottom": true, "top": true, "left": true, "right": true}

for (i = 0; i < panelIds.length; ++i) {
    var tmpPanel = panelById(panelIds[i])
    if (tmpPanel.screen == panelScreen) {
        // Ignore the new panel
        if (tmpPanel.id != panel.id) {
            freeEdges[tmpPanel.location] = false;
        }
    }
}

if (freeEdges["bottom"] == true) {
    panel.location = "bottom";
} else if (freeEdges["top"] == true) {
    panel.location = "top";
} else if (freeEdges["left"] == true) {
    panel.location = "left";
} else if (freeEdges["right"] == true) {
    panel.location = "right";
} else {
    // There is no free edge, so leave the default value
    panel.location = "top";
}

panel.height = gridUnit * 2

// Restrict horizontal panel to a maximum size of a 21:9 monitor
const maximumAspectRatio = 21/9;
if (panel.formFactor === "horizontal") {
    const geo = screenGeometry(panelScreen);
    const maximumWidth = Math.ceil(geo.height * maximumAspectRatio);

    if (geo.width > maximumWidth) {
        panel.alignment = "center";
        panel.minimumLength = maximumWidth;
        panel.maximumLength = maximumWidth;
    }
}

var kickoff = panel.addWidget("org.kde.plasma.kickoff")
kickoff.currentConfigGroup = ["Shortcuts"]
kickoff.writeConfig("global", "Alt+F1")
kickoff.writeConfig("icon", "/usr/share/icons/magos.svg")

var dolphin = panel.addWidget("org.kde.plasma.icon")
dolphin.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.dolphin.desktop")
dolphin.currentConfigGroup = ["General"]
dolphin.writeConfig("applicationName", "Dolphin")
dolphin.writeConfig("iconName", "system-file-manager")
dolphin.writeConfig("url","file:///usr/share/applications/kde5/org.kde.dolphin.desktop")

var firefox = panel.addWidget("org.kde.plasma.icon")
firefox.writeConfig("localPath", "/usr/share/applications/firefox.desktop")
firefox.currentConfigGroup = ["General"]
firefox.writeConfig("applicationName", "Firefox")
firefox.writeConfig("iconName", "firefox")
firefox.writeConfig("url","file:///usr/share/applications/firefox.desktop")

var thunderbird = panel.addWidget("org.kde.plasma.icon")
thunderbird.writeConfig("localPath", "/usr/share/applications/thunderbird.desktop")
thunderbird.currentConfigGroup = ["General"]
thunderbird.writeConfig("applicationName", "Thunderbird")
thunderbird.writeConfig("iconName", "mozilla-thunderbird")
thunderbird.writeConfig("url","file:///usr/share/applications/thunderbird.desktop")

var doublecmd = panel.addWidget("org.kde.plasma.icon")
doublecmd.writeConfig("localPath", "/usr/share/applications/doublecmd.desktop")
doublecmd.currentConfigGroup = ["General"]
doublecmd.writeConfig("applicationName", "Double Commander")
doublecmd.writeConfig("iconName", "doublecmd")
doublecmd.writeConfig("url","file:///usr/share/applications/doublecmd.desktop")

var kalc = panel.addWidget("org.kde.plasma.icon")
kalc.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.kcalc.desktop")
kalc.currentConfigGroup = ["General"]
kalc.writeConfig("applicationName", "Kalc")
kalc.writeConfig("iconName", "accessories-calculator")
kalc.writeConfig("url","file:///usr/share/applications/kde5/org.kde.kcalc.desktop")

//panel.addWidget("org.kde.plasma.showActivityManager")
var pager = panel.addWidget("org.kde.plasma.pager")
var taskmanager = panel.addWidget("org.kde.plasma.taskmanager")

var systemsettings = panel.addWidget("org.kde.plasma.icon")
systemsettings.currentConfigGroup = ["Shortcuts"]
systemsettings.writeConfig("applicationName", "KDE System Settings")
systemsettings.writeConfig("iconName", "systemsettings")
systemsettings.writeConfig("url","file:///usr/share/applications/kde5/systemsettings.desktop")

/* Next up is determining whether to add the Input Method Panel
 * widget to the panel or not. This is done based on whether
 * the system locale's language id is a member of the following
 * white list of languages which are known to pull in one of
 * our supported IME backends when chosen during installation
 * of common distributions. */
var langIds = ["as",    // Assamese
               "bn",    // Bengali
               "bo",    // Tibetan
               "brx",   // Bodo
               "doi",   // Dogri
               "gu",    // Gujarati
               "hi",    // Hindi
               "ja",    // Japanese
               "kn",    // Kannada
               "ko",    // Korean
               "kok",   // Konkani
               "ks",    // Kashmiri
               "lep",   // Lepcha
               "mai",   // Maithili
               "ml",    // Malayalam
               "mni",   // Manipuri
               "mr",    // Marathi
               "ne",    // Nepali
               "or",    // Odia
               "pa",    // Punjabi
               "sa",    // Sanskrit
               "sat",   // Santali
               "sd",    // Sindhi
               "si",    // Sinhala
               "ta",    // Tamil
               "te",    // Telugu
               "th",    // Thai
               "ur",    // Urdu
               "vi",    // Vietnamese
               "zh_CN", // Simplified Chinese
               "zh_TW"] // Traditional Chinese

if (langIds.indexOf(languageId) != -1) {
    panel.addWidget("org.kde.plasma.kimpanel");
}

panel.addWidget("org.kde.plasma.trash")
panel.addWidget("org.kde.plasma.systemtray")
panel.addWidget("org.kde.plasma.digitalclock")
panel.addWidget("org.kde.plasma.lock_logout")
EOF

[ -h /usr/share/plasma/avatars ] && exit 0

if [ -d /usr/share/plasma/avatars -a -d /usr/share/icons/gnome/48x48/emotes ] ;then
   rm -fr /usr/share/plasma/avatars
   ln -sf /usr/share/icons/gnome/48x48/emotes /usr/share/plasma/avatars
fi
exit 0
