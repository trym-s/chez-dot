# Waybar

Waybar is modeled with three independent choices:

- `layout`: where semantic modules are placed.
- `style`: visual shell such as flat or boxed.
- `view_profile`: whether modules render as text, icon, or a mixed profile.

Hosts select those choices in `.chezmoidata.yaml`:

```yaml
host_profiles:
  x230:
    waybar:
      layout: laptop_minimal
      style: flat
      view_profile: text
```

## Layouts

Layouts use semantic module names, not raw Waybar ids:

```yaml
waybar_layouts:
  laptop_minimal:
    left:
      - workspaces
    center:
      - clock
    right:
      - audio
      - brightness
      - network
      - cpu
      - temperature
      - memory
      - tray
```

This keeps modules interchangeable. `cpu` can use `custom/cpu` internally
without layouts needing to know that.

## View Profiles

View profiles decide how modules render.

```yaml
waybar_view_profiles:
  text:
    default: text
    modules: {}
  icon:
    default: icon
    modules: {}
  x230_mixed:
    default: text
    modules:
      tray: icon
```

Use `host_profiles.<name>.waybar.module_views` only for one-off host overrides:

```yaml
host_profiles:
  x230:
    waybar:
      view_profile: text
      module_views:
        network: icon
```

Precedence is:

1. Host `module_views`
2. `waybar_view_profiles.<profile>.modules`
3. `waybar_view_profiles.<profile>.default`

## Adding a Module

1. Add the semantic key to `waybar_modules`.
2. Give it a raw Waybar `id`.
3. Add `views.text` and `views.icon` when the module has alternate display
   formats.
4. Add the semantic key to any layout that should show it.
5. Render and inspect:

```sh
chezmoi execute-template < dot_config/waybar/config.tmpl
chezmoi diff ~/.config/waybar/config
```

For custom modules, prefer scripts that accept:

```sh
--view icon
--view text
```

This keeps the template simple and makes visual testing explicit.
