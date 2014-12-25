#!/bin/bash
sed -i /PrivateTmp=true/d  lib/systemd/system/cups.service
exit 0