#!/usr/bin/zsh

cd /home/marco/Github/zet
git pull
git add --all
git commit -m "$(date) ubuntu backup"
git push
