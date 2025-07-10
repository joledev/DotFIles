# 🔧 Script de Verificación y Corrección de Configuración de Alacritty
# Este script identifica y corrige configuraciones incorrectas en Alacritty

Write-Host "🔧 Verificando configuración de Alacritty..." -ForegroundColor Cyan

$configPath = "$env:APPDATA\alacritty\alacritty.toml"

if (-not (Test-Path $configPath)) {
    Write-Host "❌ No se encontró el archivo de configuración de Alacritty en: $configPath" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Archivo encontrado: $configPath" -ForegroundColor Green

# Leer configuración actual
$content = Get-Content $configPath
$newContent = @()
$changesNeeded = $false
$invalidKeys = @("opacity_mode")

Write-Host "🔍 Verificando claves de configuración..." -ForegroundColor Yellow

foreach ($line in $content) {
    $lineAdded = $false
    
    # Verificar claves inválidas
    foreach ($invalidKey in $invalidKeys) {
        if ($line -match "^\s*$invalidKey\s*=") {
            Write-Host "❌ Removiendo clave inválida: $invalidKey" -ForegroundColor Red
            $changesNeeded = $true
            $lineAdded = $true
            break
        }
    }
    
    # Si la línea no es inválida, agregarla
    if (-not $lineAdded) {
        $newContent += $line
    }
}

# Verificar si blur está habilitado
$blurEnabled = $content | Where-Object { $_ -match "^\s*blur\s*=\s*true" }
if (-not $blurEnabled) {
    Write-Host "⚠️  Blur no está habilitado explícitamente" -ForegroundColor Yellow
    
    # Buscar la sección [window] y agregar blur si no existe
    $inWindowSection = $false
    $blurAdded = $false
    $tempContent = @()
    
    foreach ($line in $newContent) {
        if ($line -match '^\[window\]') {
            $inWindowSection = $true
            $tempContent += $line
        }
        elseif ($line -match '^\[.*\]' -and $inWindowSection -and -not $blurAdded) {
            $tempContent += "# Efectos de blur (requiere compositor compatible)"
            $tempContent += "blur = true"
            $tempContent += ""
            $tempContent += $line
            $inWindowSection = $false
            $blurAdded = $true
            $changesNeeded = $true
            Write-Host "✅ Agregando configuración de blur" -ForegroundColor Green
        }
        else {
            $tempContent += $line
        }
    }
    
    if ($blurAdded) {
        $newContent = $tempContent
    }
}

# Aplicar cambios si son necesarios
if ($changesNeeded) {
    # Crear backup
    $backupPath = "$configPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $configPath $backupPath
    Write-Host "💾 Backup creado: $backupPath" -ForegroundColor Green
    
    # Guardar configuración corregida
    $newContent | Set-Content $configPath
    Write-Host "✅ Configuración corregida y guardada" -ForegroundColor Green
} else {
    Write-Host "✅ No se encontraron problemas en la configuración" -ForegroundColor Green
}

# Verificar versión de Alacritty
Write-Host "🔍 Verificando versión de Alacritty..." -ForegroundColor Yellow
try {
    $alacrittyVersion = & alacritty --version 2>$null
    if ($alacrittyVersion) {
        Write-Host "📦 Versión de Alacritty: $alacrittyVersion" -ForegroundColor Green
        
        # Verificar si la versión soporta blur
        if ($alacrittyVersion -match "(\d+)\.(\d+)\.(\d+)") {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]
            
            if ($major -ge 0 -and $minor -ge 13) {
                Write-Host "✅ Versión compatible con efectos de blur" -ForegroundColor Green
            } else {
                Write-Host "⚠️  Versión anterior - algunos efectos pueden no funcionar" -ForegroundColor Yellow
            }
        }
    }
} catch {
    Write-Host "⚠️  No se pudo determinar la versión de Alacritty" -ForegroundColor Yellow
}

# Verificar configuración actual
Write-Host "`n📊 Configuración actual:" -ForegroundColor Cyan
$currentOpacity = ($newContent | Where-Object { $_ -match "^\s*opacity\s*=" }) -replace '.*=\s*', ''
$currentBlur = ($newContent | Where-Object { $_ -match "^\s*blur\s*=" }) -replace '.*=\s*', ''

if ($currentOpacity) {
    Write-Host "   Opacidad: $currentOpacity" -ForegroundColor White
} else {
    Write-Host "   Opacidad: No configurada (usará valor por defecto)" -ForegroundColor Yellow
}

if ($currentBlur) {
    Write-Host "   Blur: $currentBlur" -ForegroundColor White
} else {
    Write-Host "   Blur: No configurado" -ForegroundColor Yellow
}

Write-Host "`n🎉 Verificación completada!" -ForegroundColor Green
Write-Host "💡 Si realizaste cambios, reinicia Alacritty para aplicarlos" -ForegroundColor Yellow
