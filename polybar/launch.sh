#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

#launch
polybar -c ~/.config/polybar/config bar1 &
polybar -c ~/.config/polybar/config bar2 &
polybar -c ~/.config/polybar/config bar3 &

echo "Bars launched....
