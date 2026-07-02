# Bootstrap

On a new Arch machine:

```sh
xargs -a ~/.local/share/chezmoi/packages/pacman.txt sudo pacman -S --needed
xargs -a ~/.local/share/chezmoi/packages/yay.txt yay -S --needed
```

Optional package modules can be installed separately:

```sh
xargs -a ~/.local/share/chezmoi/packages/modules/waybar.pacman.txt sudo pacman -S --needed
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

## ~/mnt setup

Before `chezmoi apply`, make sure local credentials exist:

```sh
ssh ac true
ssh envy true
ssh x230 true
ssh deploy true
rclone lsd gcloud:
```

Then apply and check the portable mount surface:

```sh
chezmoi apply
systemctl --user status mnt-rclone@google-drive-ravelihan.service mnt-sshfs@ac-home.service mnt-sshfs@vps-opt-hc.service
systemctl --user status rclone-gcloud-bisync-shared-local.timer
findmnt -R ~/mnt
```
