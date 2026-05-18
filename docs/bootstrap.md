# Bootstrap

On a new Arch machine:

```sh
sudo pacman -S --needed chezmoi zsh git fzf zoxide eza bat wl-clipboard
yay -S --needed zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-theme-powerlevel10k-git
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
