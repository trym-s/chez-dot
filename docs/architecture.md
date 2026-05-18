# Architecture

The repository uses one source tree for all machines.

- Base behavior lives in templates such as `dot_zshrc.tmpl`.
- Shared data lives in `.chezmoidata.yaml`.
- Local machine choices live outside the repo in
  `~/.config/chezmoi/chezmoi.toml`.

The first layer manages only zsh and Powerlevel10k. Other terminal or desktop
configs should be added later using the same pattern: generic template plus
small profile data. Theme names are generic system themes, not prompt-specific
themes, so kitty, tmux, yazi, nvim, and prompt can all consume the same value.

## Host profiles

Host profiles are declared under `host_profiles` in `.chezmoidata.yaml`.
Each machine selects a profile with:

```toml
[data]
host_profile = "vlhnhp"
```

This keeps the repo explicit while keeping machine-local state small.
