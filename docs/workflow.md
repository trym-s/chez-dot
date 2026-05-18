# Workflow

## Change a managed file

1. Edit source in `~/.local/share/chezmoi`.
2. Review with `chezmoi diff`.
3. Apply with `chezmoi apply`.
4. Commit from the source repo.

## Add a host profile

1. Add a new entry under `host_profiles` in `.chezmoidata.yaml`.
2. On that machine, set `host_profile` in `~/.config/chezmoi/chezmoi.toml`.
3. Run `chezmoi diff` and `chezmoi apply`.

## Keep layers small

Add new domains one at a time. Keep each tool's core behavior in its source
template, and keep profile/theme differences in `.chezmoidata.yaml`.
