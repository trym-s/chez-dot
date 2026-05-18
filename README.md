# Dotfiles

Chezmoi-managed Arch dotfiles. The current scope covers shell prompt files,
kitty, and Hyprland configuration.

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
theme-driven regions.

## First scope

- `dot_zshrc.tmpl`: generic zsh base loader.
- `dot_p10k.zsh.tmpl`: prompt layout and host-aware colors.
- `.chezmoidata.yaml`: shared profiles, themes, shell data, and Hyprland host data.
- `dot_config/hypr/`: modular Hyprland configuration with host-aware monitor
  and NVIDIA includes.
- `packages/`: Arch package inputs split by `pacman` and `yay`.
- `~/.config/chezmoi/chezmoi.toml`: local machine selection.
