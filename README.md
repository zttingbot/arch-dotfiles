# arch-dotfiles

Dotfiles for a keyboard-driven Arch Linux desktop: i3 on X11. Managed with
[chezmoi](https://www.chezmoi.io/).

- **Desktop:** i3, i3status-rust, picom
- **Launcher and notifications:** rofi, dunst
- **Terminal:** Ghostty, tmux
- **Shell:** zsh, starship

## Install

```sh
sudo pacman -S --needed chezmoi git
chezmoi init zttingbot/arch-dotfiles
chezmoi diff
chezmoi apply
```

`apply` installs the packages, writes the configs and clones TPM.

## After installing

1. **Font:** install a Nerd Font. The configs use MonoLisa Nerd Font Mono,
   which is paid; to use another, change its name in the Ghostty, i3, dunst
   and i3status-rust configs.
2. **Shell:** `chsh -s /usr/bin/zsh`
3. **Wallpaper:** `feh --bg-fill <image>`
4. **Start:** `startx` from a TTY
5. **tmux plugins:** press `C-a I` inside tmux

## Customize

- **Local settings:** put machine-specific changes in `~/.zshrc.local` or
  `~/.config/tmux/tmux.local.conf`. They are untracked and loaded last, so
  they override the repo.
- **Packages:** add them to `run_onchange_before_install-packages.sh`; the
  next `chezmoi apply` installs them.
- **Configs:** edit the file in `~`, then run `chezmoi re-add` to copy it into
  the repo.
- **Colors and fonts:** the header of each config lists the ones it uses,
  and its "Kept in sync" notes name the other files that share them. See
  [STYLE.md](STYLE.md).
- **Updates:** `chezmoi update` pulls the latest changes and applies them.

## License

[MIT](LICENSE)
