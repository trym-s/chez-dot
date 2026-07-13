# Migration notes

Dated, cross-machine follow-ups. When applying this repo on another host, check
the "Pending on other hosts" items.

## 2026-07-13 — home cleanup + Yazi/tmux fix (WSL host)

Changes captured into source on the WSL host and pushed:

- **GOPATH moved out of `$HOME`.** `dot_config/zsh/zshrc.tmpl` now exports
  `GOPATH="$HOME/.local/share/go"` and prepends `$GOPATH/bin` to `PATH`, so no
  `~/go` directory appears in home.
- **Powerlevel10k path.** The non-system fallback now sources
  `~/.local/share/zsh/plugins/powerlevel10k/...` instead of `~/powerlevel10k`.
  The system-package branch (`/usr/share/zsh-theme-powerlevel10k`) is unchanged.
- **chezmoi (was snap) + yazi (was snap)** replaced with `~/.local/bin`
  binaries; the `~/snap` directory was removed. Real state was always outside
  snap (`~/.config/{chezmoi,yazi}`, `~/.local/share/chezmoi`), so nothing lost.
- **Zsh plugin source paths unified to the WSL host's layout** (per request):
  - fzf-tab, zsh-history-substring-search → `~/.local/share/zsh/plugins/...`
  - zsh-autosuggestions, zsh-syntax-highlighting → `/usr/share/zsh-*` (not
    `/usr/share/zsh/plugins/...`).
- **tmux Yazi TRT / window-jump fix** in `dot_tmux.conf.tmpl`:
  - `set -g allow-passthrough on` (lets apps talk to the terminal through tmux;
    clears the "Terminal response timeout" from Yazi).
  - Window nav moved off `M-[` / `M-]` to `M-,` / `M-.`. `M-[` is the CSI
    introducer (`ESC [`); Yazi's `DA1`/`DSR` query responses were being parsed
    as `M-[` and triggered `previous-window`, jumping to another tab.

### Pending on other hosts

- **go dir:** after `chezmoi apply` + a new shell, `GOPATH` points to
  `~/.local/share/go`, but an existing `~/go` will not move itself. Run once:
  `mv ~/go ~/.local/share/go` (or delete it).
- **Zsh plugin paths:** the source now hardcodes the WSL host's plugin
  locations. On a host where plugins live elsewhere (e.g.
  `/usr/share/zsh/plugins/...`), the `[[ -r ... ]]` guards fail silently and
  those plugins won't load. If a plugin goes missing, reconcile the paths —
  ideally by making them host-profile-driven per `docs/layering-guide.md`
  instead of hardcoding.
