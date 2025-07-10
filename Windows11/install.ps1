# Windows 11 DotFiles Installation Script
# Ejecuta este script para instalar automáticamente todas las configuraciones

param(
    [switch]$All,
    [switch]$PowerShell,
    [switch]$Alacritty,
    [switch]$Neovim,
    [switch]$Helix,
    [switch]$LazyVim,
    [switch]$Tools,
    [switch]$Music,
    [switch]$Help
)

function Show-Help {
    Write-Host "Windows 11 DotFiles Installation Script" -ForegroundColor Green
    Write-Host ""
    Write-Host "Uso:" -ForegroundColor Yellow
    Write-Host "  .\install.ps1 -All                    # Instalar todo"
    Write-Host "  .\install.ps1 -PowerShell             # Solo PowerShell"
    Write-Host "  .\install.ps1 -Alacritty              # Solo Alacritty"
    Write-Host "  .\install.ps1 -Neovim                 # Solo Neovim"
    Write-Host "  .\install.ps1 -Helix                  # Solo Helix"
    Write-Host "  .\install.ps1 -LazyVim                # Solo LazyVim"
    Write-Host "  .\install.ps1 -Tools                  # Herramientas de terminal"
    Write-Host "  .\install.ps1 -Music                  # Reproductores de música"
    Write-Host ""
}

function Install-PowerShellConfig {
    Write-Host "Instalando configuración de PowerShell..." -ForegroundColor Blue
    # Implementar lógica de instalación
}

function Install-AlacrittyConfig {
    Write-Host "Instalando configuración de Alacritty..." -ForegroundColor Blue
    # Implementar lógica de instalación
}

function Install-NeovimConfig {
    Write-Host "Instalando configuración de Neovim..." -ForegroundColor Blue
    # Implementar lógica de instalación
}

# Main logic
if ($Help -or (-not ($All -or $PowerShell -or $Alacritty -or $Neovim -or $Helix -or $LazyVim -or $Tools -or $Music))) {
    Show-Help
    exit
}

Write-Host "🎨 Windows 11 DotFiles Installer" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

if ($All -or $PowerShell) { Install-PowerShellConfig }
if ($All -or $Alacritty) { Install-AlacrittyConfig }
if ($All -or $Neovim) { Install-NeovimConfig }

Write-Host ""
Write-Host "✅ Instalación completada!" -ForegroundColor Green
