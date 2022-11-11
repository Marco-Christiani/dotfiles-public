#!/bin/zsh

source ~/.config/aliases.zsh
# printf "Running \`gw -l 1 $REPO_DIR/phobos-log\`\n"
# printf "Running \`gw -l 1 $REPO_DIR/quant-research-toolbox/*.md\`\n"
tmux new-window -n watchers \; \
	send-keys 'gw -l 1 $REPO_DIR/phobos-log' C-m \; \
	split-window -h\; \
	send-keys 'gw -l 1 $REPO_DIR/quant-research-toolbox/*.md' C-m \;



