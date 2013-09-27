#!/bin/bash
rpm --delsign cache/*.rpm
for a in cache/*.rpm ;do
    rpm -ihv --noscripts --nodeps $a || exit 1
done
echo Done.
