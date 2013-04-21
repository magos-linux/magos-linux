#!/bin/bash
for a in cache/*.rpm ;do
    rpm -ihv --nodigest --noscripts --nosignature $a
done
echo Done.
