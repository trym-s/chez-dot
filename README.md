# Dotfiles

Chezmoi-managed Arch dotfiles. This repository starts with the shell prompt
layer only: zsh plus Powerlevel10k.

## Daily workflow

```sh
chezmoi diff
chezmoi apply
chezmoi cd
git status
```

Edit source files in `~/.local/share/chezmoi`, not rendered files in `$HOME`,
unless you intentionally plan to capture the rendered change back into source.

## First scope

- `dot_zshrc.tmpl`: generic zsh base loader.
- `dot_p10k.zsh.tmpl`: prompt layout and host-aware colors.
- `.chezmoidata.yaml`: shared profiles, colors, and prompt data.
- `~/.config/chezmoi/chezmoi.toml`: local machine selection.
