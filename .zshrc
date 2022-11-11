source ~/.config/env
# Zsh Config -------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
# setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.
# setopt HIST_IGNORE_DUPS        # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_FIND_NO_DUPS       # Do not display a line previously found.
# setopt HIST_BEEP               # Beep when accessing nonexistent history.

# Make right alt work for zmk/qmk keyboards
xmodmap -e "keycode 108 = Alt_R Meta_R Alt_R Meta_R"


# Antigen Plugins --------------------------------------------------------------
source $HOME/antigen.zsh
antigen use oh-my-zsh

# marlonrichert/zsh-autocomplete
# https://github.com/marlonrichert/zsh-autocomplete/blob/main/.zshrc

# '': Start each new command line with normal autocompletion.
# history-incremental-search-backward: Start in live history search mode.
zstyle ':autocomplete:*' default-context ''

zstyle ':autocomplete:*' min-delay 0.1
zstyle ':autocomplete:*' fzf-completion no

# '..##': Don't show completions for the current word, if it consists of two or more dots.
# '':     Always show completions.
zstyle ':autocomplete:*' ignored-input '' # extended glob pattern
# no:  Tab inserts the top completion.
# yes: Tab first inserts a substring common to all listed completions, if any.
zstyle ':autocomplete:*' insert-unambiguous no

# Wait until this many characters have been typed, before showing completions.
zstyle ':autocomplete:*' min-input 0  # characters (int)

# complete-word: (Shift-)Tab inserts the top (bottom) completion. (default)
# menu-complete: Press again to cycle to next (previous) completion.
# menu-select:   Same as `menu-complete`, but updates selection in menu.
# zstyle ':autocomplete:*' widget-style complete-word

# Autocomplete automatically selects a backend for its recent dirs completions.
# So, normally you won't need to change this.
# However, you can set it if you find that the wrong backend is being used.
zstyle ':autocomplete:recent-dirs' backend zxoxide
# cdr:  Use Zsh's `cdr` function to show recent directories as completions.
# no:   Don't show recent directories.
# zsh-z|zoxide|z.lua|z.sh|autojump|fasd: Use this instead (if installed).

# robbyrussell/oh-my-zsh plugins
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle colored-man-pages
antigen bundle fzf
antigen bundle aliases

# zsh-users plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions  # adds additional completions
antigen bundle zsh-users/zsh-autosuggestions # shows ghost text

# Third Party plugins
# antigen bundle marlonrichert/zsh-autocomplete@main 
# hash of last working commit: d8bfbef46efc54c1189010a3b70d501b44487504
# https://github.com/marlonrichert/zsh-autocomplete/tree/d8bfbef46efc54c1189010a3b70d501b44487504
antigen bundle /home/marco/.antigen/custom-bundles/zsh-autocomplete@last-working-commit

# conda completion (in addition to the built in, to detect env names I think)
antigen bundle esc/conda-zsh-completion
# remind me to use my aliases https://github.com/djui/alias-tips
antigen bundle djui/alias-tips
# antigen bundle Tarrasch/zsh-autoenv
# antigen bundle zplugin/zsh-exa@main
# DarrinTisdale/zsh-aliases-exa @ master
# Yeah this vi mode thing breaks everything and I aint got time for that, use kitty emulation
# antigen bundle jeffreytse/zsh-vi-mode # ESC or C-[ to enter vi mode
antigen apply
# ------------------------------------------------------------------------------

# Source custom files ----------------------------------------------------------
# ORDER IS INTENTIONAL
source ~/.config/env # be SUPER SURE no one overwrites these
source ~/.config/aliases.zsh  # Uses functions
source ~/.config/keybindings.zsh # Uses aliases and functions
# Load this last bc aliases and bindings dont need to be defined until runtime
source ~/.config/functions.zsh  
# ------------------------------------------------------------------------------

# Initialize starship
eval "$(starship init zsh)"

# initialize zoxide
eval "$(zoxide init zsh)"
# DONT EDIT BELOW HERE
# Nvim things ------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# ------------------------------------------------------------------------------

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/marco/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/marco/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/marco/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/marco/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

