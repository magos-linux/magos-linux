#!/bin/bash
[ ! -x /usr/bin/telegram-desktop -a -x /usr/bin/Telegram ] && ln -sf Telegram /usr/bin/telegram-desktop
[ -x /usr/bin/telegram-desktop ] || exit 0
PFP=/usr/share/applications/telegramdesktop.desktop
[ -f $PFP ] && exit 0
cat > $PFP  <<EOF
[Desktop Entry]
Version=1.5
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
Comment[ru]=Клиент мессенджера Telegram
TryExec=telegram-desktop
Exec=telegram-desktop -- %u
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
Actions=Quit;
SingleMainWindow=true
X-GNOME-UsesNotifications=true
X-GNOME-SingleWindow=true

[Desktop Action Quit]
Exec=telegram-desktop -quit
Name=Quit Telegram
Icon=application-exit
EOF
chmod 444 $PFP
exit 0
