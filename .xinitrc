#!/bin/bash

exec dwm & wmpid=$!
ntpd -qg
hwclock -w
xset r rate 280 40
wait $wmpid
mpv --no-video /etc/login.wav &
