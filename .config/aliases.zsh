# System -----------------------------------------------------------------------
alias hg="history | grep"
alias rm="trash"
alias aapt="sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt clean"
alias ai="sudo apt install"
alias ar="sudo apt remove"
alias arp="sudo apt remove --purge"
alias asn="apt search --names-only"
alias asa="apt search"
alias ls="exa --long --group-directories-first --header --classify --created --changed --color-scale --icons"
alias la="ls --list-dirs --all .*"  # only show hidden files bc why else would I add the -a flag
alias galg="acs git | grep" # grep git aliases using cheatsheet.py script
alias esudo="sudo -E env "PATH=$PATH" nettop;" # sudo w user PATH for access to user installed programs (i.e. ~/.local/bin)
alias cp='cp -i' # ask before overwriting
alias mv='mv -i' # ask before overwriting

# Quick edit configs, sort of deprecated in favor of bm_dirs
alias ea="vim $ALIAS_FILE"                  # edit aliases.zsh
alias ez="vim ~/.zshrc"                     # edit .zshrc
alias ef="vim ~/.config/functions.zsh"      # edit functions.zsh
alias ek="vim ~/.config/keybindings.zsh"    # edit keybindings.zsh
alias sz="source ~/.zshrc"                  # source .zshrc

# bmlast foo -> Add last run command to bookmarked commands file
alias bmlast="fc -ln -1 >> $CONFIG_DIR/bookmarked-cmds.txt"

alias pmomentum='cd /home/marco/Github/overreaction-momentum; conda deactivate; ca momentum; vim *.todo || vim'
alias poneoff='cd /home/marco/Github/one-off-research; conda deactivate; ca one-off-research; vim *.todo || vim'

# Python -----------------------------------------------------------------------
# alias pyi="ipython -i" # if ptpython is being moody
alias pyi="ptpython -i"
alias pml="cd $REPO_DIR/pairs-ml-strategy; conda deactivate; conda activate pairsml; vim"
alias pa="cd $REPO_DIR/portfolio-allocation; conda deactivate; conda activate portfolio-allocation; vim"
alias sce="setup_conda_env"  # iteratively deactivate then activate passed env
alias ca="conda activate"

# Taskwarrior ------------------------------------------------------------------
alias ta="task add"
alias t="taskwarrior-tui"

# Tmuxinator
alias tx="tmuxinator"
alias swork="tx start work"  # Start work layout 
alias ework="tx edit work"  # Edit work layout

# Application ------------------------------------------------------------------
alias vim="lvim"
alias code="code --force-device-scale-factor=1 --ignore-gpu-blacklist --enable-gpu-rasterization --enable-native-gpu-memory-buffers"
alias r="ranger"
alias enw="emacs -nw"

# Yadm -------------------------------------------------------------------------
alias yst="yadm status"
alias ya="yadm add"
alias yaf="yadm add -f"  # force add a new untracked/ignored file
alias yaa="yadm add --all"
alias yc="yadm commit -m"
alias yp="yadm push"
alias yl="yadm pull"


# Bat --------------------------------------------------------------------------
alias cat='bat'
# Colorize help messages with bat
# alias bathelp='batcat --plain --language=help'
alias bathelp='bat --plain --language=help'


# Scripts aliases bc im too lazy to write a package with entry points ----------
# TODO: No. This repo is deprecated, merge with dotfiles.
alias cg="$CONDA_PYTHON_EXE $REPO_DIR/custom-linux-config/comgen.py"
alias autocommit="$CONDA_PYTHON_EXE $REPO_DIR/Daily-Git-Commit/main.py"


# Appended by alast (non-essential) --------------------------------------------
alias log_vol="vim ~/Github/phobos-log/vol-overlay.md"
alias gw="gitwatch -r origin -m '🔄 %d'"
alias gwl="gitwatch -r origin -l 1"
alias cab="conda activate base"
alias applekb="setxkbmap us -model pc105 -option caps:escape_shifted_capslock"
# switch to colemak and fix right Alt key (it sends "Left 3 Shift" aka keycode 108)
alias kyria='setxkbmap us colemak && xmodmap -e "keycode 108 = Alt_R"'
alias c="clear"  # for vim popup term bc C-l is bound to switch pane
alias fixcondapml="conda deactivate; conda deactivate; conda activate pairsml; which python"
alias fixcondapa="conda deactivate; conda deactivate; conda activate portfolio-allocation; which python"
alias fixcondaa="conda deactivate; conda deactivate; conda activate ares; which python"
alias fixcondat="conda deactivate; conda deactivate; conda activate trend; which python"
alias tt="taskwarrior-tui"
alias lt="exa --tree --level 2"
alias cpml="~/Github/pairs-ml-strategy/; fixcondapml"
alias todo="todoist --namespace --project-namespace list | fzf --preview 'todoist show {1}' | cut -d ' ' -f 1 | tr '\n' ' '"
alias mdr1000="pacmd set-default-sink "alsa_output.pci-0000_41_00.1.hdmi-stereo-extra1""
alias aclean="sudo apt autoremove -y && sudo apt autoclean -y && sudo aptitude update"
alias bkf="bindkey -L | fzf"
