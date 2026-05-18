# Host Profiles

Current profiles:

- `vlhnhp`: local laptop profile using the harbor prompt theme.
- `laptop`: generic mobile machine profile using harbor.
- `workstation`: generic desktop profile using graphite.
- `server`: minimal remote/server profile using mono.
- `lab`: experimental or disposable host profile using violet.
- `default`: fallback profile for new machines.

Use `theme = "rose"` in local `chezmoi.toml` or in a host profile to select
the red/yellow palette derived from the current Yazi theme.

Add future machines by copying `default`, then changing only the values that
actually differ.
