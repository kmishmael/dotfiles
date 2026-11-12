#!/bin/sh
# Install all packages tracked in this repo's packages/ lists.
# Runs only when something is actually missing, so it is a safe no-op on
# machines that are already up to date.

set -eu

SOURCE_DIR="{{ .chezmoi.sourceDir }}"
NATIVE="$SOURCE_DIR/packages/native.txt"
AUR="$SOURCE_DIR/packages/aur.txt"

if ! command -v pacman >/dev/null 2>&1; then
    echo "==> pacman not found, skipping package install"
    exit 0
fi

[ -f "$NATIVE" ] || exit 0

missing_native="$(comm -23 <(sort "$NATIVE") <(pacman -Qqen | sort))"
if [ -n "$missing_native" ]; then
    echo "==> Installing missing native packages:"
    echo "$missing_native"
    sudo pacman -S --needed - < "$NATIVE"
else
    echo "==> All native packages already installed"
fi

if [ -f "$AUR" ]; then
    if command -v yay >/dev/null 2>&1; then
        missing_aur="$(comm -23 <(sort "$AUR") <(yay -Qqem | sort))"
        if [ -n "$missing_aur" ]; then
            echo "==> Installing missing AUR packages:"
            echo "$missing_aur"
            yay -S --needed - < "$AUR"
        else
            echo "==> All AUR packages already installed"
        fi
    else
        echo "==> yay not found; install it, then run 'chezmoi apply' again for AUR packages"
    fi
fi

# oh-my-zsh is a plain git clone (.zshrc sources it)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Cloning oh-my-zsh"
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" \
        || echo "==> WARNING: could not clone oh-my-zsh"
fi

# uv is installed via its official installer (fish config sources ~/.local/bin/env.fish)
if [ ! -x "$HOME/.local/bin/uv" ]; then
    echo "==> Installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh \
        || echo "==> WARNING: could not install uv"
fi
