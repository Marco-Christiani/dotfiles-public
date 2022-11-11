#!/bin/bash

# Create a desktop entry neovim that calls this script, passing it the filename
# Then, have xdg-open use that desktop entry to open files

# alacritty --command tmux attach || tmux \; new-window \; send-keys 'htop' C-m \;
# alacritty --command tmux \; new-window \; send-keys 'htop' C-m \;
# alacritty --command /bin/zsh -c "tmux || tmux attach ; tmux new-window "
alacritty --command tmux \; new-window \; send-keys "lvim $1" C-m \;

if [ -z "$(xwininfo -root -children | grep 'Alacritty')" ]
 then
   # echo 'aint open'
   alacritty
 # else
 #   echo 'alacritty is open'
fi
