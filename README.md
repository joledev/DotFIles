# DotFiles

Personal configuration files for Windows 11 development environment.

## Structure

```
Windows11/
├── Alacritty/      # Terminal emulator
├── PowerShell/     # Shell configuration
├── Neovim/         # Text editor
├── Helix/          # Modern text editor
├── LazyVim/        # Neovim distribution
├── Terminal-Tools/ # CLI utilities (lf, yazi, lazygit)
├── Music-Players/  # Terminal music players
├── Wallpapers/     # Desktop backgrounds
└── Scripts/        # Automation scripts
```

## Setup

```powershell
git clone https://github.com/joledev/DotFIles.git
cd DotFIles/Windows11
.\install.ps1 -All
```

## Core Tools

- **Terminal**: Alacritty
- **Shell**: PowerShell 7.5.2
- **Editor**: Neovim/Helix
- **File Manager**: lf, yazi
- **Git UI**: lazygit
- **Search**: fzf, ripgrep
- **File Operations**: fd, bat

## Installation Notes

- Each directory contains installation instructions
- Templates use placeholders for user-specific paths
- Backup existing configs before applying
- Configurations are modular - use what you need

## Requirements

- Windows 11
- PowerShell 7.5.2+
- Git
- Package manager (Scoop/Chocolatey recommended)
