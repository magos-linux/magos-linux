#!/bin/bash

[ -h /etc/alternatives/soundprofile ] || ln -sf /etc/sound/profiles/pulse /etc/alternatives/soundprofile

exit 0
