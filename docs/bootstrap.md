# Bootstrap

On a new Arch machine:

```sh
xargs -a ~/.local/share/chezmoi/packages/pacman.txt sudo pacman -S --needed
xargs -a ~/.local/share/chezmoi/packages/yay.txt yay -S --needed
```

Initialize this repository:

```sh
chezmoi init <repo-url>
mkdir -p ~/.config/chezmoi
$EDITOR ~/.config/chezmoi/chezmoi.toml
chezmoi diff
chezmoi apply
```

Minimal local config:

```toml
[data]
host_profile = "default"
```

Use a host-specific profile when one exists:

```toml
[data]
host_profile = "vlhnhp"
```
