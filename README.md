# Dotfiles

Personal configuration files for my development environment.

## Contents

This repository contains configuration files for:

- **Codex** - Shared agent instructions installed to `~/.codex/AGENTS.md`
- **Agents** - Shared agent skills installed to `~/.agents/skills`
- **WezTerm** – Terminal emulator configuration
- **Zsh** – Shell configuration and customizations
- **Claude Code** - Shared agent skills installed to `~/.claude/skills`
- **Aerospace** – Window manager workspace definitions
- **SketchyBar** – macOS status bar, items, and themes
- **JankyBorders** – Window border styling via borders.app
- **Maccy** – Lightweight clipboard manager

## Structure

```text
dotfiles/
├── agents/
│   └── .agents/skills/                    # Shared agent skills
├── aerospace/
│   └── .aerospace.toml                     # Aerospace workspace configuration
├── claude/
│   └── .claude/skills -> ../../agents/.agents/skills
│                                          # Claude Code shares the same skills
├── codex/
│   └── .codex/AGENTS.md                    # Shared Codex agent instructions
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

Claude Code and Codex CLI are optional and are skipped by default. To install either one, pass the matching option; selected packages are also included in `stow`:

```bash
./install.sh --with-claude
./install.sh --with-codex
./install.sh --with-claude --with-codex
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
- Install Codex CLI, only when `--with-codex` is provided
- Install Claude Code, only when `--with-claude` is provided
- Install Aspire CLI
- Install dotnet-ef global tool (if dotnet is installed)
- Install Rust (via rustup)
- Create symlinks to your home directory, including optional packages only when selected

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
   # Install default configurations
   stow -vt ~ agents aerospace jankyborders sketchybar wezterm zsh

   # Include optional Claude and Codex configurations if wanted
   stow -vt ~ agents aerospace claude codex jankyborders sketchybar wezterm zsh
   ```

   ```bash
   # Or install specific configurations
   stow -vt ~ agents
   stow -vt ~ aerospace
   stow -vt ~ claude
   stow -vt ~ codex
   stow -vt ~ jankyborders
   stow -vt ~ sketchybar
   stow -vt ~ wezterm
   stow -vt ~ zsh
   ```

   - `-t ~` = target is your home folder (where symlinks will be created)
   - `-v` = verbose output so you can see what's happening

   `claude` and `codex` are optional stow packages. Include them only if you want those agent configurations linked.

   If `~/.agents/skills` or `~/.claude/skills` already exist as regular directories or files, move or remove them before running `stow` with the `agents` or `claude` packages so it does not fail with conflicts.

   If `~/.codex/AGENTS.md` already exists as a regular file, move or remove it before running `stow` so the `codex` package can create the symlink cleanly.

4. Restart your terminal or source the configurations:

   ```bash
   source ~/.zshrc
   ```

## Uninstallation

To remove symlinks created by Stow:

```bash
cd /path/to/dotfiles
stow -Dvt ~ aerospace
stow -Dvt ~ agents
stow -Dvt ~ claude
stow -Dvt ~ codex
stow -Dvt ~ jankyborders
stow -Dvt ~ sketchybar
stow -Dvt ~ wezterm
stow -Dvt ~ zsh

# Or uninstall all packages at once
stow -Dvt ~ agents aerospace jankyborders sketchybar wezterm zsh

# Include optional Claude and Codex packages if you installed them
stow -Dvt ~ agents aerospace claude codex jankyborders sketchybar wezterm zsh
```
