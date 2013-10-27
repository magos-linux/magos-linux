#!/bin/bash
rpm --addsign rpms/* 
#rpm --delsign rpms/* 
chmod 444 rpms/*
echo Done.
