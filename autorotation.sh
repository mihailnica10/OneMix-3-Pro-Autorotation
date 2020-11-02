#!/bin/sh

killall monitor-sensor
monitor-sensor > /dev/shm/sensor.log 2>&1 &
xrandr -o left
xinput set-prop 15 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
while inotifywait -e modify /dev/shm/sensor.log; do
ORIENTATION=$(tail /dev/shm/sensor.log | grep 'orientation' | tail -1 | grep -oE '[^ ]+$')
case "$ORIENTATION" in
bottom-up)
xrandr -o right
xinput set-prop 15 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1;;
normal)
xrandr -o left
xinput set-prop 15 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1;;
right-up)
xrandr -o normal
xinput set-prop 15 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1;;
left-up)
xrandr -o inverted
xinput set-prop 15 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1;;
esac
done
