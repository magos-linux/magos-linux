#!/bin/bash
sed -i 's|COMMAND_NETCAT|COMMAND_NETCAT 2>/dev/null|' usr/bin/nxserver
exit 0
