# Host Profiles

Current profiles:

- `vlhnhp`: this machine.
- `x230`: SSH host `x230`.
- `ac`: SSH host `ac`.
- `default`: fallback profile for new machines.

Use `theme = "rose"` in local `chezmoi.toml` to select the red/yellow palette
derived from the current Yazi theme. Host profiles do not select themes.

Add future machines by copying `default`, then changing only the values that
actually differ.
