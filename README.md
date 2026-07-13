# Dotfiles

Chezmoi-managed Arch dotfiles. The current scope covers shell, prompt, tmux,
kitty, Neovim, and Hyprland configuration.

This repository is my portable Linux workstation setup. It is designed around a
terminal-first workflow: reproducible dotfiles, shell automation, keyboard-driven
tools, host-aware configuration, and open-source desktop components that can be
moved across machines without rebuilding the environment by hand.

## Daily workflow

```sh
chezmoi diff
chezmoi apply
chezmoi cd
git status
```

Edit source files in `~/.local/share/chezmoi`, not rendered files in `$HOME`,
unless you intentionally plan to capture the rendered change back into source.
See `docs/layering-guide.md` for how to add files, profile differences, and
theme-driven regions. See `docs/migration-notes.md` for cross-machine
follow-ups to run when applying this repo on another host.

## Workflow highlights

- Chezmoi templates for host-aware configuration and machine profiles.
- Modular Neovim, zsh, tmux, kitty, and Hyprland setup.
- Arch package lists split between `pacman` and `yay` inputs.
- User-level systemd templates for SSHFS, rclone mount, and bisync workflows.
- Portable mount layout for cloud, personal, SSH, and VPS surfaces.

## Managed scope

- `dot_zshrc`: minimal zsh entrypoint that loads the managed config.
- `dot_config/zsh/zshrc.tmpl`: generic zsh config and shell integrations.
- `dot_config/p10k/p10k.zsh.tmpl`: prompt layout and host-aware colors.
- `dot_tmux.conf.tmpl`: tmux keybindings, pane/window behavior, and themed status.
- `dot_config/kitty/kitty.conf.tmpl`: kitty terminal settings and theme.
- `dot_config/nvim/`: modular Neovim config with generated core palette.
- `.chezmoidata.yaml`: shared profiles, themes, shell data, and Hyprland host data.
- `dot_config/hypr/`: modular Hyprland configuration with host-aware monitor
  and NVIDIA includes.
- `dot_mnt/`: portable `~/mnt` README layout for cloud, personal, SSH, and VPS mount surfaces.
- `dot_config/systemd/user/`: portable template user services for `~/mnt` SSHFS, rclone mount, and bisync units.
- `dot_config/mnt/`: per-instance mount definitions consumed by the systemd templates.
- `packages/`: Arch package inputs split by `pacman`, `yay`, and optional modules.
- `~/.config/chezmoi/chezmoi.toml`: local machine selection.
