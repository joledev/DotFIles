# PowerShell 7.5.2 Configuration

Esta carpeta contiene toda la configuración para PowerShell 7.5.2 en Windows 11.

## Archivos incluidos:
- `Microsoft.PowerShell_profile.ps1` - Perfil principal de PowerShell
- `functions.ps1` - Funciones personalizadas
- `aliases.ps1` - Alias personalizados
- `modules.ps1` - Módulos y configuraciones adicionales

## Instalación:
1. Copia `Microsoft.PowerShell_profile.ps1` a `$PROFILE` location
2. Ejecuta `Get-Location $PROFILE` para encontrar la ubicación correcta
3. Reinicia PowerShell

## Ubicación típica del perfil:
```
C:\Users\[username]\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

## Dependencias:
- PowerShell 7.5.2+
- Módulos adicionales listados en modules.ps1
