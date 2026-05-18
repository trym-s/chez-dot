# Layering Guide

This repository uses chezmoi as a layered dotfiles system. The goal is to keep
the common behavior obvious, while making machine-specific differences explicit
and small.

## Core Idea

Every managed file has two possible kinds of content:

- **Core**: behavior that should be the same on every machine.
- **Difference area**: values or small switches that vary by host profile or
  theme.

Core belongs in the template itself. Differences belong in data.

Good:

```gotemplate
font_family {{ $ui.font_family }}
font_size {{ $ui.terminal_font_size }}
```

Bad:

```gotemplate
{{ if eq .host_profile "x230" }}
font_size 12.5
{{ else }}
font_size 11
{{ end }}
```

The bad version leaks host names into the template. The good version says:
"this file needs a font family and size", and data decides what those values
are.

## Where Things Live

Source files live in:

```text
~/.local/share/chezmoi
```

Machine-local selection lives in:

```text
~/.config/chezmoi/chezmoi.toml
```

Shared data lives in:

```text
~/.local/share/chezmoi/.chezmoidata.yaml
```

Rendered files live in `$HOME`, for example:

```text
dot_zshrc.tmpl      -> ~/.zshrc
dot_p10k.zsh.tmpl   -> ~/.p10k.zsh
```

Edit source files first, then render:

```sh
chezmoi cd
nvim dot_zshrc.tmpl
chezmoi diff
chezmoi apply
```

## Data Model

The main data groups are:

```yaml
themes:
  rose:
    bg: "08090a"
    fg: "d7d7d7"
    accent: "e11d48"
    dir: 167
    prompt_ok: 107

host_profiles:
  laptop:
    theme: harbor
    machine_role: laptop
    path_roots:
      dev: "~/dev(|/*)"
      config: "~/.config(|/*)"
```

Local config selects the profile and can override the theme:

```toml
[data]
host_profile = "laptop"
theme = "rose"
```

The profile says what kind of machine this is. The theme says what visual
language to use. A template consumes both.

## How Templates Read Data

Use this pattern at the top of a template when it needs profile/theme data:

```gotemplate
{{- $profileName := "default" -}}
{{- if hasKey . "host_profile" -}}{{- $profileName = .host_profile -}}{{- end -}}
{{- $profile := index .host_profiles $profileName -}}
{{- $themeName := $profile.theme -}}
{{- if hasKey . "theme" -}}{{- $themeName = .theme -}}{{- end -}}
{{- $theme := index .themes $themeName -}}
```

Then use `$profile` for machine role and paths:

```gotemplate
{{ $profile.path_roots.dev }}
{{ $profile.machine_role }}
```

Use `$theme` for visual values:

```gotemplate
{{ $theme.bg }}
{{ $theme.fg }}
{{ $theme.accent }}
```

## Adding a New Managed File

Example: add Yazi theme management.

1. Create the source path that maps to the target path:

   ```text
   dot_config/yazi/theme.toml.tmpl -> ~/.config/yazi/theme.toml
   ```

2. Put core structure in the template:

   ```toml
   #:schema https://yazi-rs.github.io/schemas/theme.json

   [app]
   overall = { bg = "#{{ $theme.bg }}" }

   [mgr]
   cwd = { fg = "#{{ $theme.accent }}", bold = true }
   border_style = { fg = "#{{ $theme.surface }}" }
   ```

3. Review the render:

   ```sh
   chezmoi diff ~/.config/yazi/theme.toml
   ```

4. Apply:

   ```sh
   chezmoi apply ~/.config/yazi/theme.toml
   ```

5. Commit:

   ```sh
   chezmoi cd
   git add dot_config/yazi/theme.toml.tmpl .chezmoidata.yaml
   git commit -m "Add yazi theme"
   ```

## Adding New Structure to an Existing File

Example: add an optional zsh helper function.

If every machine should get it, put it directly in `dot_zshrc.tmpl`:

```zsh
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}
```

If only some profiles should get it, add a boolean to profile data:

```yaml
host_profiles:
  laptop:
    zsh:
      enable_mkcd: true
```

Then gate the block in the template:

```gotemplate
{{- if $profile.zsh.enable_mkcd }}
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}
{{- end }}
```

Keep the condition about capability or behavior, not host name. Prefer
`enable_mkcd` over `if host_profile == "laptop"`.

## Core vs Difference Area

Use this rule:

- If changing it would affect the way the tool works everywhere, it is core.
- If changing it expresses machine identity, role, size, path, or visual taste,
  it is data.

Examples:

| Area | Core | Difference |
|---|---|---|
| zsh | plugin load order | enable/disable optional helper |
| p10k | segment layout logic | theme colors, SSH state colors |
| yazi | TOML section structure | colors/icons from theme |
| kitty | shell command | font size, opacity, theme |
| tmux | prefix and navigation model | status colors, status position |
| nvim | plugin list and keymaps | colorscheme name, font/UI density |

## Adding a New Theme

Add a new entry under `themes`:

```yaml
themes:
  glacier:
    bg: "0b1014"
    fg: "d8e2ea"
    accent: "7dd3fc"
    surface: "16202a"
    muted: "6b7280"
    dir: 81
    dir_anchor: 117
    git_clean: 114
    git_dirty: 179
    git_conflict: 203
    prompt_ok: 114
    prompt_error: 203
    ssh_default: 81
    ssh_prod: 203
    ssh_stage: 179
    ssh_dev: 75
```

Use hex values for tools that accept true color. Use numeric values for p10k
terminal color fields until p10k templates are moved fully to hex-capable
styling.

Test without changing the local machine:

```sh
chezmoi execute-template --override-data '{"theme":"glacier"}' \
  < dot_p10k.zsh.tmpl > /tmp/p10k-glacier.zsh
zsh -n /tmp/p10k-glacier.zsh
```

## Adding a New Host Profile

Add a profile:

```yaml
host_profiles:
  x230:
    theme: rose
    machine_role: laptop
    path_roots:
      dev: "~/dev(|/*)"
      config: "~/.config(|/*)"
```

On that machine, select it:

```toml
[data]
host_profile = "x230"
```

If the same host should temporarily use another theme:

```toml
[data]
host_profile = "x230"
theme = "graphite"
```

Local config is the only machine-local file required for selection.

## Review Commands

Use these before applying:

```sh
chezmoi diff
chezmoi status
```

Render one template manually:

```sh
chezmoi execute-template < dot_p10k.zsh.tmpl > /tmp/p10k.zsh
zsh -n /tmp/p10k.zsh
```

Show managed files:

```sh
chezmoi managed
```

Check repo state:

```sh
chezmoi cd
git status --short
```

## Rules of Thumb

- Do not put host names directly into templates.
- Do not create a new profile for a small visual preference; use `theme`.
- Do not create a new theme for a single tool; themes are system-wide.
- Keep managed layers small. Add one domain at a time.
- Add docs when introducing a new pattern.
- Prefer `chezmoi diff` before every `chezmoi apply`.
