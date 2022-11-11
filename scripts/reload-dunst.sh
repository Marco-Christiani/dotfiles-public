#!/bin/bash

echo 'killing dunst...'
pkill '^dunst$'
sleep 0.5

echo 'Restarting...'
dunst -config ~/.config/dunst/dunstrc &
sleep 0.5

echo 'Sending test notifs'

notify-send -u critical "Test message: critical test"

notify-send -u normal "Test message: normal test 2"

notify-send -u low "Test message: low test 3"
sleep 3
dunstctl close-all
