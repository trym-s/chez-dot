# Package Modules

Install package modules explicitly on Arch Linux:

```sh
xargs -a ~/.local/share/chezmoi/packages/modules/base.pacman.txt sudo pacman -S --needed
xargs -a ~/.local/share/chezmoi/packages/modules/waybar.pacman.txt sudo pacman -S --needed
```

`packages/pacman.txt` and `packages/yay.txt` remain the flat bootstrap lists.
