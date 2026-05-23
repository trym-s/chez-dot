# Agent Instructions

This repository is a chezmoi-managed dotfiles source tree. Keep changes small,
data-driven, and compatible with the existing layering model:

- Shared data lives in `.chezmoidata.yaml`.
- Machine-local selections live in `~/.config/chezmoi/chezmoi.toml` or in
  `host_profiles` when the setting belongs to a host profile.
- Templates should express structure. Data should express choices.
- Do not hardcode host names in templates when data can describe the difference.

## Waybar Module Requests

When the user asks to add, change, or test a Waybar module, do not immediately
invent the full module. First gather the module contract with concise questions.
Ask only what is missing from local context.

Required questions for a new Waybar module:

1. What is the semantic module name?
   Example: `disk`, `vpn`, `bluetooth`, `weather`, `docker`, `keyboard`.
2. What data source should it use?
   Examples: Waybar built-in module, shell command, existing script, system
   file, dbus command, network call.
3. Should it support both `text` and `icon` views?
   If yes, ask what each view should display.
4. Which layouts should include it, and in which section?
   Valid sections are `left`, `center`, and `right`.
5. Which hosts or view profiles should show which view?
   Prefer `waybar_view_profiles` for reusable behavior and
   `host_profiles.<host>.waybar.module_views` for host-only overrides.
6. What click, scroll, tooltip, interval, and warning/critical behavior is
   expected?

If the user gives enough information up front, proceed without asking repeated
questions.

## Waybar Data Model

Use semantic module keys everywhere outside the raw module registry.

Layouts must use semantic keys:

```yaml
waybar_layouts:
  laptop_minimal:
    right:
      - network
      - cpu
      - memory
```

The raw Waybar id belongs only in `waybar_modules`:

```yaml
waybar_modules:
  cpu:
    id: "custom/cpu"
```

View selection belongs to view profiles or host profile overrides:

```yaml
waybar_view_profiles:
  text:
    default: text
    modules: {}
  icon:
    default: icon
    modules: {}

host_profiles:
  x230:
    waybar:
      view_profile: text
      module_views:
        network: icon
```

Precedence for the rendered view is:

1. `host_profiles.<host>.waybar.module_views.<module>`
2. `waybar_view_profiles.<profile>.modules.<module>`
3. `waybar_view_profiles.<profile>.default`

## Adding a Waybar Module

Follow this implementation sequence:

1. Add or update `waybar_modules.<semantic_key>` in `.chezmoidata.yaml`.
2. If the module is custom, add a script under `dot_local/bin/` using chezmoi's
   executable naming convention, for example:

   ```text
   dot_local/bin/executable_waybar-disk
   ```

3. Custom scripts should accept:

   ```sh
   --view icon
   --view text
   ```

   They should print Waybar JSON:

   ```json
   {"text":"...","tooltip":"...","class":"..."}
   ```

4. Add both `views.icon` and `views.text` in `.chezmoidata.yaml` unless the
   module is genuinely display-invariant. If it is display-invariant, use a
   plain `config` block.
5. Add the semantic module key to the requested `waybar_layouts`.
6. Update `waybar_view_profiles` or host `module_views` only when view selection
   differs from the selected profile default.
7. Update `docs/waybar.md` if the module introduces a new convention.

## Validation

Before finishing Waybar work, run these checks from the chezmoi source dir:

```sh
chezmoi execute-template < dot_config/waybar/config.tmpl | jq empty
chezmoi execute-template < dot_config/waybar/style.css.tmpl >/tmp/waybar-style.css
chezmoi diff ~/.config/waybar/config
```

For host-specific rendering, use override data:

```sh
chezmoi execute-template --override-data '{"host_profile":"x230","theme":"rose"}' < dot_config/waybar/config.tmpl | jq empty
```

For custom scripts, run both views directly:

```sh
sh dot_local/bin/executable_waybar-example --view icon
sh dot_local/bin/executable_waybar-example --view text
```

Do not apply unrelated chezmoi changes. If the worktree already contains
unrelated modified files, leave them alone and mention that they were not part
of the Waybar change.
