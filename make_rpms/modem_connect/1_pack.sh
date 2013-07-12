#!/bin/bash
NAME=modem_connect
VERSION=$(grep -i ^version: SPECS/*.spec | awk '{print $2}')
cd SOURCES
tar -czf $NAME-$VERSION.tar.gz $NAME
cd ..
