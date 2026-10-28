#!/bin/sh
# Package installer.
#
# Run by `chezmoi apply` before it writes anything, and again whenever this
# file changes, since chezmoi reruns a run_onchange_ script when its contents
# do. Each group appends to the argument list, so pacman runs once, last, with
# every package. Groups follow the desktop from the bottom up: the X session,
# then what runs on it, then the terminal. Full reference:
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
#
# Missing on purpose:
#   git                      a requirement, installed with chezmoi before
#                            `chezmoi init` (see README.md), which clones
#                            with it.
#   MonoLisa Nerd Font Mono  a paid font, installed by hand into
#                            ~/.local/share/fonts.

# =============================================================================
# Packages
# =============================================================================

# --- X session ---------------------------------------------------------------

# .xinitrc starts i3, which runs the bar, picom and feh.
set -- xorg-server xorg-xinit i3-wm i3status-rust picom feh

# --- Notifications and launcher ----------------------------------------------

# dunst and rofi, with the Adwaita Sans font they share with i3.
set -- "$@" dunst rofi adwaita-fonts

# --- Media and screenshot keys -----------------------------------------------

# i3's media and screenshot keys. pactl and the bar's sound block talk to a
# PulseAudio server, which pipewire-pulse provides.
set -- "$@" libpulse pipewire-pulse maim xclip

# --- Terminal and shell ------------------------------------------------------

# The terminal and the shell inside it, with everything .zshrc loads. Neovim
# comes with what its config needs to build parsers (tree-sitter-cli, gcc) and
# to install tools through Mason (unzip, python).
set -- "$@" ghostty tmux zsh zsh-autosuggestions zsh-syntax-highlighting \
  starship fzf zoxide mise neovim tree-sitter-cli gcc unzip python

# =============================================================================
# Install
# =============================================================================

# --needed skips packages that are already up to date, so a rerun only
# installs what is missing or out of date. exec makes pacman's exit status the
# script's, so a failed install stops the apply before it writes configs for
# programs that are not there.
exec sudo pacman -S --needed "$@"
