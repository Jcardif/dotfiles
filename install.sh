#!/bin/bash

# Dotfiles Installation Script
# This script installs all necessary packages and creates symlinks

set -e  # Exit on error

INSTALL_CLAUDE=false
INSTALL_CODEX=false

usage() {
    cat <<EOF
Usage: ./install.sh [options]

Options:
  --with-claude                 Include Claude Code installation and stow package
  --with-codex                  Include Codex CLI installation and stow package
  -h, --help                    Show this help message
EOF
}

is_enabled() {
    [ "$1" = true ]
}

for arg in "$@"; do
    case "$arg" in
        --with-claude)
            INSTALL_CLAUDE=true
            ;;
        --with-codex)
            INSTALL_CODEX=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $arg"
            usage
            exit 1
            ;;
    esac
done

echo "🚀 Starting dotfiles installation..."

# Install fonts
echo "📦 Installing fonts..."
brew install font-meslo-lg-nerd-font font-jetbrains-mono-nerd-font font-sf-pro font-fira-code font-fira-code-nerd-font

# Install wezterm
echo "📦 Installing wezterm..."
brew install --cask wezterm

# Install powerlevel10k
echo "📦 Installing powerlevel10k..."
brew install powerlevel10k

# Setup zsh-autosuggestions plugin
echo "📦 Installing zsh-autosuggestions..."
brew install zsh-autosuggestions

# Setup zsh-syntax-highlighting
echo "📦 Installing zsh-syntax-highlighting..."
brew install zsh-syntax-highlighting

# Install eza (better ls)
echo "📦 Installing eza..."
brew install eza

# Install zoxide (better cd)
echo "📦 Installing zoxide..."
brew install zoxide

# Install stow
echo "📦 Installing stow..."
brew install stow

# Install uv (Astral)
echo "📦 Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv is available in this shell session
export PATH="$HOME/.local/bin:$PATH"

# Install latest Python and expose default python/python3 executables
echo "📦 Installing default Python with uv..."
if command -v uv &> /dev/null; then
    uv python install --default
else
    echo "⚠️  Warning: uv was not found on PATH after installation. Skipping Python installation."
    echo "   Please ensure ~/.local/bin is on your PATH, then run: uv python install --default"
fi

# Install aerospace
echo "📦 Installing aerospace..."
brew install --cask nikitabobko/tap/aerospace

# Install Sketchy bar
echo "📦 Installing sketchybar..."
brew tap FelixKratz/formulae
brew install sketchybar

# Install janky borders
echo "📦 Installing janky borders..."
brew install borders

# Install Maccy
echo "📦 Installing Maccy clipboard manager..."
brew install maccy

# Install GitHub CLI
echo "📦 Installing GitHub CLI..."
brew install gh

# Install GitHub Copilot CLI
echo "📦 Installing GitHub Copilot CLI..."
brew install copilot-cli

# Install Codex CLI
if is_enabled "$INSTALL_CODEX"; then
    echo "📦 Installing Codex CLI..."
    brew install codex
else
    echo "⏭️  Skipping Codex CLI installation..."
fi

# Install Claude Code
if is_enabled "$INSTALL_CLAUDE"; then
    echo "📦 Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "⏭️  Skipping Claude Code installation..."
fi

# Create the symlinks
echo "🔗 Creating symlinks with stow..."
stow_packages=(agents aerospace)

if is_enabled "$INSTALL_CLAUDE"; then
    stow_packages+=(claude)
fi

if is_enabled "$INSTALL_CODEX"; then
    stow_packages+=(codex)
fi

stow_packages+=(jankyborders sketchybar wezterm zsh)

stow -vt ~ "${stow_packages[@]}"

# Install Aspire CLI
echo "📦 Installing Aspire CLI..."
curl -sSL https://aspire.dev/install.sh | bash

# Install dotnet-ef global tool (requires dotnet to be installed first)
echo "📦 Installing dotnet-ef global tool..."
if command -v dotnet &> /dev/null; then
    dotnet tool install --global dotnet-ef
else
    echo "⚠️  Warning: dotnet is not installed. Skipping dotnet-ef installation."
    echo "   Please install dotnet first, then run: dotnet tool install --global dotnet-ef"
fi

# Install Rust
echo "📦 Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "✅ Installation complete!"
echo ""
echo "🎉 All done! Please open WezTerm to see everything set up properly."
echo "   You can start WezTerm from Applications or run 'open -a WezTerm' from terminal."
