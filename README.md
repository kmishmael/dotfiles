# Dotfiles

EndeavourOS + niri + DankMaterialShell, managed with chezmoi.

## What's tracked

- `niri/` — full compositor config incl. `dms/` include files (binds, colors, layout, alttab, outputs, cursor, input, windowrules)
- `dms/` — DankMaterialShell settings, plugin lock/settings, firefox.css
- `DankMaterialShell` — symlink to `dms` (matches the work machine layout)
- `ghostty/`, `nvim/` (LazyVim), `fish/`, `starship.toml`
- `gtk-3.0/`, `gtk-4.0/` — DMS-generated GTK theming
- `environment.d/`, `systemd/` — session env + autostart symlinks (dms.service, syncthing.service)
- `.zshrc`, `.gitconfig`, `mimeapps.list`, `user-dirs.dirs`
- `packages/` — native + AUR package lists (excluded from apply via `.chezmoiignore`)
- `.chezmoiscripts/run_once_install-packages.sh` — installs missing packages,
  clones oh-my-zsh, installs uv. Idempotent no-op on up-to-date machines.

## Restore on a new machine

```sh
# 1. Base tools
sudo pacman -S --needed chezmoi git

# 2. yay (AUR helper) — needed BEFORE first apply so AUR packages install
sudo pacman -S --needed --asdeps git base-devel
cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# 3. Copy this repo over (from the other machine):
#    rsync -a ~/.local/share/chezmoi/ <target>:.local/share/chezmoi/
#    (or via syncthing, USB, etc.)

# 4. Apply everything + install all packages
chezmoi apply

# 5. Reboot and log into the niri session
```

Notes:
- AUR packages include `greetd-dms-greeter-git` — the greeter session entry.
- DMS re-downloads plugins (e.g. worldClock) from `plugins.lock.json` on launch.
- `systemd/` autostart symlinks (dms, syncthing) are restored by chezmoi.
- Per-machine output config (`dms/outputs.kdl`) may need adjusting if the
  new machine's displays differ.
