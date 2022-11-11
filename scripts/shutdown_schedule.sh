#!/bin/bash

opts="today 0900,today 0930,today 1000,today 1030,today 1100,today 1130,tomorrow 0900,tomorrow 0930,tomorrow 1000,tomorrow 1030,tomorrow 1100,tomorrow 1130"

# Separate entries with newlines via awk and pipe to fzf
choice=$(echo $opts | awk 'BEGIN {FS=","} {for( i=1; i<=NF; i++ ) print $i}' | fzf)

boot_time=$(date +\%s -d "$choice") # as unix timestamp
hrf=$(date -d @$boot_time) # human readable format
# Confirm selection with user
echo "Selection: $choice"
echo "Timestamp: $boot_time"
echo "Date: $hrf"
cmd="sudo /usr/sbin/rtcwake -u -m off -t $boot_time >> /tmp/rtcwake.log 2>&1"
echo "Command: $cmd"
read -e -p "Confirm shutdown NOW and boot at $hrf? [y/n] " confirm
if [ "$confirm" == 'y' ]; then
  eval $cmd
else
  echo 'Cancelled.'
fi
