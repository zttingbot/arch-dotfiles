# arch-dotfiles

Dotfiles for a keyboard-driven Arch Linux desktop: i3 on X11. Managed with
[chezmoi](https://www.chezmoi.io/).

- **Desktop:** i3, i3status-rust, picom
- **Launcher and notifications:** rofi, dunst
- **Terminal:** Ghostty, tmux
- **Shell:** zsh, starship

Not included: the MonoLisa font and a wallpaper.

## Install

```sh
sudo pacman -S --needed chezmoi git
chezmoi init zttingbot/arch-dotfiles
chezmoi diff
chezmoi apply
```

`apply` installs the packages, writes the configs and clones TPM and, if
`~/.config/nvim` is missing,
[zttingbot/neovim-config](https://github.com/zttingbot/neovim-config).

## After installing

1. **Font:** install a Nerd Font. The configs use MonoLisa Nerd Font Mono,
   which is paid; to use another, change its name in the Ghostty, i3, dunst
   and i3status-rust configs. In Ghostty, also delete the four `font-style`
   lines and `font-synthetic-style`, or set the styles to the new font's own
   names (`fc-list : family style` lists them). They name MonoLisa's cuts, and
   with synthesized styles off, bold or italic text can come out regular.
2. **Shell:** `chsh -s /usr/bin/zsh`
3. **Node.js:** `mise install`, before the first `nvim`: Mason installs some
   of its tools with npm, and mise doesn't install Node on its own.
4. **Start:** `startx` from a TTY
5. **Wallpaper:** `feh --bg-fill <image>` in a terminal; i3 restores it on
   every start.
6. **tmux plugins:** press `C-a I` inside tmux
7. **Neovim:** a config of your own needs
   [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
   with its [tmux backend](https://github.com/smart-splits-nvim/backend-tmux)
   for tmux's `C-h/j/k/l` and `M-h/j/k/l` to reach Neovim.

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
