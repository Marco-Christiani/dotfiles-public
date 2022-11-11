#!/bin/sh
# export WINIT_UNIX_BACKEND=x11

# ~/.local/bin/neovide-launcher.sh
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"$HOME/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$HOME/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$HOME/.cache/lvim"}"
export NEOVIDE_FRAMELESS=1

# exec neovide -- -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" --frame=NONE "$@"
# echo neovide --frame=none --maximized -- -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"
exec neovide --frame=none --maximized -- -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"
