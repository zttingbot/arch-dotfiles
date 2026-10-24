#!/bin/sh
# Package installer.
#
# Run by `chezmoi apply` before it writes anything, and again whenever this
# file changes, since chezmoi reruns a run_onchange_ script when its contents
# do. --needed skips packages that are already up to date, so a rerun only
# installs what is missing or out of date. Full reference:
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
#
# MonoLisa Nerd Font Mono is missing on purpose: it is a paid font, installed
# by hand into ~/.local/share/fonts.
#
# Kept in sync with .chezmoiexternal.toml
#   - git is listed, and this script runs before_ rather than after_, because
#     the TPM entry there is cloned with git during the same apply.

# The X session: .xinitrc starts i3, which runs the bar, picom and feh.
set -- xorg-server xorg-xinit i3-wm i3status-rust picom feh

# dunst and rofi, with the Adwaita Sans font they share with i3.
set -- "$@" dunst rofi adwaita-fonts

# i3's media and screenshot keys. pactl and the bar's sound block talk to a
# PulseAudio server, which pipewire-pulse provides.
set -- "$@" libpulse pipewire-pulse maim xclip

# The terminal and the shell inside it, with everything .zshrc loads.
set -- "$@" ghostty tmux zsh zsh-autosuggestions zsh-syntax-highlighting \
  starship fzf zoxide fnm neovim

# git, for the TPM clone; see "Kept in sync" above.
set -- "$@" git

exec sudo pacman -S --needed "$@"
