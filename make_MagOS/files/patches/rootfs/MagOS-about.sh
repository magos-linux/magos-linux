#!/bin/bash
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
exit 0
