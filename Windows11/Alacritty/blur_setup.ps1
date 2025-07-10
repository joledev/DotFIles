# 🌊 Script de configuración de Blur para Alacritty en Windows
# Este script configura efectos de blur y transparencia mejorados

param(
    [string]$BlurLevel = "medium"
)

Write-Host "🌊 Configurando efectos de blur para Alacritty..." -ForegroundColor Cyan

# Configuraciones de blur por nivel
$BlurConfigs = @{
    "light" = @{
        "opacity" = 0.92
        "acrylic" = $false
        "description" = "Blur ligero para máxima legibilidad"
    }
    "medium" = @{
        "opacity" = 0.88
        "acrylic" = $true
        "description" = "Blur medio - balance perfecto"
    }
    "heavy" = @{
        "opacity" = 0.82
        "acrylic" = $true
        "description" = "Blur intenso para efectos visuales"
    }
    "extreme" = @{
        "opacity" = 0.75
        "acrylic" = $true
        "description" = "Blur extremo - máximo efecto visual"
    }
}

if (-not $BlurConfigs.ContainsKey($BlurLevel)) {
    Write-Host "❌ Nivel de blur no válido. Usa: light, medium, heavy, extreme" -ForegroundColor Red
    exit 1
}

$config = $BlurConfigs[$BlurLevel]
$configPath = "$env:APPDATA\alacritty\alacritty.toml"

Write-Host "⚙️  Aplicando configuración: $($config.description)" -ForegroundColor Green

# Función para actualizar configuración TOML
function Update-TomlConfig {
    param(
        [string]$FilePath,
        [string]$Key,
        [string]$Value
    )
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath
        $newContent = @()
        $inWindowSection = $false
        $opacityUpdated = $false
        
        foreach ($line in $content) {
            if ($line -match '^\[window\]') {
                $inWindowSection = $true
                $newContent += $line
            }
            elseif ($line -match '^\[.*\]' -and $inWindowSection) {
                if (-not $opacityUpdated) {
                    $newContent += "opacity = $Value"
                    $opacityUpdated = $true
                }
                $inWindowSection = $false
                $newContent += $line
            }
            elseif ($inWindowSection -and $line -match "^$Key\s*=") {
                $newContent += "$Key = $Value"
                $opacityUpdated = $true
            }
            else {
                $newContent += $line
            }
        }
        
        $newContent | Set-Content $FilePath
        Write-Host "✅ Configuración actualizada en $FilePath" -ForegroundColor Green
    }
}

# Actualizar configuración de opacidad
Update-TomlConfig -FilePath $configPath -Key "opacity" -Value $config.opacity

# Configurar efectos de Windows para blur mejorado
Write-Host "🪟 Configurando efectos de Windows..." -ForegroundColor Yellow

# Registrar configuración de blur para Alacritty
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
try {
    # Habilitar transparencia del sistema
    Set-ItemProperty -Path $registryPath -Name "EnableTransparency" -Value 1 -ErrorAction SilentlyContinue
    Write-Host "✅ Transparencia del sistema habilitada" -ForegroundColor Green
    
    # Habilitar efectos de blur
    $dwmPath = "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
    if (-not (Test-Path $dwmPath)) {
        New-Item -Path $dwmPath -Force | Out-Null
    }
    Set-ItemProperty -Path $dwmPath -Name "EnableAeroPeek" -Value 1 -ErrorAction SilentlyContinue
    Write-Host "✅ Efectos de blur de Windows habilitados" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️  No se pudieron aplicar todas las configuraciones del sistema" -ForegroundColor Yellow
}

# Crear archivo de configuración para Neovim
$nvimBlurConfig = @"
-- Configuración automática de blur para Neovim
-- Generado por blur_setup.ps1

require('config.transparency').setup('$BlurLevel')
require('config.transparency').alacritty_integration()
"@

$nvimConfigPath = "$env:LOCALAPPDATA\nvim\lua\config\blur_auto.lua"
$nvimBlurConfig | Set-Content $nvimConfigPath
Write-Host "✅ Configuración de Neovim actualizada" -ForegroundColor Green

# Mostrar resumen
Write-Host "`n🎨 Configuración de blur aplicada:" -ForegroundColor Cyan
Write-Host "   Nivel: $BlurLevel" -ForegroundColor White
Write-Host "   Opacidad: $($config.opacity)" -ForegroundColor White
Write-Host "   Descripción: $($config.description)" -ForegroundColor White

Write-Host "`n🔄 Reinicia Alacritty para aplicar los cambios completamente" -ForegroundColor Yellow
Write-Host "💡 Usa los atajos de teclado en Neovim para ajustar el blur:" -ForegroundColor Green
Write-Host "   <leader>ub - Ciclar niveles de blur" -ForegroundColor White
Write-Host "   <leader>ut - Toggle transparencia" -ForegroundColor White
