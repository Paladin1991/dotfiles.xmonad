#!/bin/bash
if pgrep polybar; then
    killall -q polybar
    polybar -r example &
    exit 1
else
    polybar -r example &
fi

setxkbmap -model abnt2 -layout br -variant abnt2
picom -b --config ~/.xmonad/scripts/picom.conf
~/.fehbg &
exec /usr/lib/xfce4/notifyd/xfce4-notifyd &
eww daemon
xsetroot -cursor_name left_ptr &
exit