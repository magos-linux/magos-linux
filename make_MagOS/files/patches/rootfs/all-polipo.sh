#!/bin/sh
[ -f etc/polipo/config ] && sed -i s/"dnsUseGethostbyname.*"/'dnsUseGethostbyname = false'/ etc/polipo/config
exit 0

