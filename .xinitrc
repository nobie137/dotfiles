#!/bin/bash

exec dwm & wmpid=$!
#exec /usr/libexec/notification-daemon &
ntpd -qg
hwclock -w
imwheel
xset r rate 280 40
feh --bg-scale --no-fehbg $HOME/Pictures/Wallpapers/Castles/hohenzollern-castle.jpg
aplay -f CD /etc/login.wav &
wait $wmpid
