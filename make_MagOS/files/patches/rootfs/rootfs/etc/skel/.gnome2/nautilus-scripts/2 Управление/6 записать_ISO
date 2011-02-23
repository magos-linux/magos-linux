#!/bin/sh
#  Placed into the Public Domain 2/2002 by Shane T. Mueller
#  This will use cdrecord to burn an .iso file to your ard-coded
#  cd-rom writer
#  You should do a cdrecord -scanbus to determine the dev setting
#  for your cd-rom writing device.  For me, it looked like this:
# $ cdrecord -scanbus
# Cdrecord 1.10 (i686-pc-linux-gnu) Copyright (C) 1995-2001 Jörg Schilling
# Linux sg driver version: 3.1.22
# Using libscg version 'schily-0.5'
# scsibus0:
# 	0,0,0	  0) 'IOMEGA  ' 'ZIP 100         ' '13.A' Removable Disk
#	0,1,0	  1) 'HP      ' 'CD-Writer+ 8100 ' '1.0g' Removable CD-ROM
#	0,2,0	  2) *
#	0,3,0	  3) *
#	0,4,0	  4) *
#	0,5,0	  5) *
#	0,6,0	  6) *
#	0,7,0	  7) *
#
# I chose dev=0,1,0.  speed can also be adjusted to suit your needs.
cdrecord -v -data dev=0,1,0 speed=8 $1
