#!/bin/bash
mkdir -p usr/share/mdk/about
ln -sf index-ru-magos.html usr/share/mdk/about/index-ru.html
ln -sf index-ru-magos.html usr/share/mdk/about/index.html
cat >usr/share/mdk/desktop/powerpack/register.desktop <<EOF
#!/usr/bin/env xdg-open
[Desktop Entry]
Encoding=UTF-8
Icon=register-mdv
Name=MagOS Support
Name[ru]=Сайт поддержки MagOS
Type=Link
URL=http://www.magos-linux.ru/
EOF
rm -f usr/share/mdk/desktop/free/*
ln -sf ../powerpack/register.desktop usr/share/mdk/desktop/free/register.desktop
exit 0
