# Architecture

The repository uses one source tree for all machines.

- Base behavior lives in templates such as `dot_config/zsh/zshrc.tmpl`.
- Shared data lives in `.chezmoidata.yaml`.
- Local machine choices live outside the repo in
  `~/.config/chezmoi/chezmoi.toml`.

Managed layers currently include zsh, Powerlevel10k, tmux, kitty, Neovim, and
Hyprland. New terminal, editor, or desktop configs should follow the same
pattern: generic template plus small profile data. Theme names are generic
system themes, not prompt-specific themes, so kitty, tmux, yazi, nvim, and
prompt can all consume the same value.
Current themes are `rose`, `harbor`, `graphite`, `ember`, `violet`, `mono`, and `paper`.

## Host profiles

Host profiles are declared under `host_profiles` in `.chezmoidata.yaml`.
Each machine selects a profile with:

```toml
[data]
host_profile = "vlhnhp"
```

This keeps the repo explicit while keeping machine-local state small.
