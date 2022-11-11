#!/usr/bin/zsh

yadm pull
# Only update files tracked in the index
yadm add --update
yadm commit -m "$(date) ubuntu backup"
yadm push
