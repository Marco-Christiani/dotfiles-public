#!/bin/bash

tmux new-window -n monitor \; \
  send-keys 'htop' C-m \; \
  split-window -v \; \
  send-keys 'watch nvidia-smi' C-m \; 
