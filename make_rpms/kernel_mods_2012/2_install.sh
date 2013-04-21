#!/bin/bash
for a in cache/*.rpm ;do
    rpm -ihv --noscripts $a || exit 1
done
echo Done.
