# Dotfiles

Personal configuration files for my development environment.

## Contents

This repository contains configuration files for:

- **WezTerm** – Terminal emulator configuration
- **Zsh** – Shell configuration and customizations
- **Aerospace** – Window manager workspace definitions
- **SketchyBar** – macOS status bar, items, and themes
- **JankyBorders** – Window border styling via borders.app
- **Maccy** – Lightweight clipboard manager

## Structure

```text
dotfiles/
├── aerospace/
│   └── .aerospace.toml                     # Aerospace workspace configuration
├── jankyborders/
│   └── .config/borders/bordersrc           # Borders.app theme
├── sketchybar/
│   └── .config/sketchybar/…                # SketchyBar items, plugins, and themes
├── wezterm/
│   └── .wezterm.lua                        # WezTerm configuration
└── zsh/
    └── .zshrc                              # Zsh shell configuration
```

## Installation

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) for managing symlinks.

### Quick Install (Recommended)

Clone this repository and run the installation script:

```bash
git clone https://github.com/Jcardif/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

The installation script will:
- Install required Nerd Fonts (Meslo LG, JetBrains Mono, SF Pro)
- Install WezTerm terminal emulator
- Install Powerlevel10k theme
- Install Zsh plugins (autosuggestions, syntax-highlighting)
- Install modern CLI tools (eza, zoxide)
- Install GNU Stow for symlink management
- Install Aerospace window manager
- Install SketchyBar status bar
- Install Janky Borders (borders.app)
- Install Maccy clipboard manager
- Install GitHub CLI (gh)
- Install GitHub Copilot CLI
- Install Codex CLI
- Install Claude Code
- Install Aspire CLI
- Install dotnet-ef global tool (if dotnet is installed)
- Install Rust (via rustup)
- Create symlinks to your home directory

### Manual Installation

If you prefer to install components manually:

#### Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow
```

#### Setup

1. Clone this repository (anywhere you like, e.g., `~/source/repos/`):

   ```bash
   git clone https://github.com/Jcardif/dotfiles.git
   cd dotfiles
   ```

2. Install the required packages (see the `install.sh` script for the complete list)

3. Use Stow to create symlinks to your home directory:

   ```bash
   # Install all configurations
   stow -vt ~ aerospace jankyborders sketchybar wezterm zsh
   ```

   ```bash
   # Or install specific configurations
   stow -vt ~ aerospace
   stow -vt ~ jankyborders
   stow -vt ~ sketchybar
   stow -vt ~ wezterm
   stow -vt ~ zsh
   ```

   - `-t ~` = target is your home folder (where symlinks will be created)
   - `-v` = verbose output so you can see what's happening

3. Restart your terminal or source the configurations:

   ```bash
   source ~/.zshrc
   ```

## Uninstallation

To remove symlinks created by Stow:

```bash
cd /path/to/dotfiles
stow -Dvt ~ aerospace
stow -Dvt ~ jankyborders
stow -Dvt ~ sketchybar
stow -Dvt ~ wezterm
stow -Dvt ~ zsh

# Or uninstall all packages at once
stow -Dvt ~ aerospace jankyborders sketchybar wezterm zsh
```
