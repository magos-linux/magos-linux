#!/bin/bash
rpm --addsign rpms/* srpms/*
#rpm --delsign rpms/* srpms/*
chmod 444 rpms/*
chmod 444 srpms/*
