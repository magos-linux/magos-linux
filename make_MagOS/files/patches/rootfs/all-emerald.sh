#!/bin/bash
[ -d usr/share/emerald/theme ] || exit 0
rm -f usr/share/emerald/theme/*
cp -p usr/share/emerald/themes/Adonis_Mod/*  usr/share/emerald/theme

