#!/bin/bash

sed -i /MagOS-Server/d etc/hosts
echo "192.168.1.31               MagOS-Server" >> etc/hosts
exit 0
