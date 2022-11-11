## Important Notes
Linux Keymaps:
  - Important file to learn more: /usr/share/X11/xkb/rules
  - *The following is how to set capslock to ESC and shift-capslock to capslock*
  - Test remap with command: `setxkbmap -model pc105 -option caps:escape_shifted_capslock`
    - Can check keyboard model with `setxkbmap -query`
    - Can check config with `setxkbmap -print`
  - Use symlink in .config/keyboard (-> /etc/default/keyboard )
    - Add option: `caps:escape_shifted_capslock`
  - Default apple kb function row to function (i.e. f1, f2...) press fn key for alternate function (play/pause/etc)
  `echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf`
  - More info here: https://github.com/free5lot/hid-apple-patched

## Requirements

```bash
# https://github.com/zsh-users/antigen
curl -L git.io/antigen > antigen.zsh
```

```bash
# https://github.com/alacritty/alacritty/blob/master/INSTALL.md
```

```bash
# https://github.com/ranger/ranger
pip install ranger-fm
```

```bash
# https://github.com/neovim/neovim
sudo apt install neovim
# OR
brew install neovim
```

```bash
# https://github.com/andreafrancia/trash-cli
pip install trash-cli
# OR
sudo apt install trash-cli
```

```bash
# https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

```bash
# https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

```bash
brew install exa
```
## Fonts
### Mac
```
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-mono-nerd-font
```

## Other

### Bluetooth MACs

- Kyria: E5:7A:D9:51:38:3E
- MDR-1000X: 04:5D:4B:66:0F:F9 
- Apple KB Bluetooth MAC: 

## Vimium remaps for colemak

```
# colemak layout for link hints
mapKey <d:f> g
mapKey <e:f> k
mapKey <f:f> e
mapKey <g:f> t
mapKey <i:f> l
mapKey <j:f> y
mapKey <k:f> n
mapKey <l:f> u
mapKey <n:f> j
mapKey <o:f> p
mapKey <p:f> r
mapKey <r:f> s
mapKey <s:f> d
mapKey <t:f> f
mapKey <u:f> i
mapKey <y:f> o
mapKey <D:f> G
mapKey <E:f> K
mapKey <F:f> E
mapKey <G:f> T
mapKey <I:f> L
mapKey <J:f> Y
mapKey <K:f> N
mapKey <L:f> U
mapKey <N:f> J
mapKey <O:f> P
mapKey <P:f> R
mapKey <R:f> S
mapKey <S:f> D
mapKey <T:f> F
mapKey <U:f> I
mapKey <Y:f> O
```
