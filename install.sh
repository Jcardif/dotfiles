#!/bin/bash

# Dotfiles Installation Script
# This script installs all necessary packages and creates symlinks

set -e  # Exit on error

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

# Create the symlinks
echo "🔗 Creating symlinks with stow..."
stow -vt ~ aerospace jankyborders sketchybar wezterm zsh

echo "✅ Installation complete!"
echo ""
echo "🎉 All done! Please open WezTerm to see everything set up properly."
echo "   You can start WezTerm from Applications or run 'open -a WezTerm' from terminal."
