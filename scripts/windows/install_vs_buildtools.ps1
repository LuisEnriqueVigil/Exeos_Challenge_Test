# Script para descargar Visual Studio Build Tools
# Ejecutar en PowerShell como Administrador

Write-Host "Descargando Visual Studio Build Tools..." -ForegroundColor Yellow

# Descargar Build Tools
$url = "https://aka.ms/vs/17/release/vs_buildtools.exe"
$output = "$env:TEMP\vs_buildtools.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host "Descarga completada." -ForegroundColor Green
    
    Write-Host "Ejecutando instalador..." -ForegroundColor Yellow
    
    # Instalar con componentes necesarios para Flutter
    Start-Process -FilePath $output -ArgumentList @(
        "--quiet",
        "--wait",
        "--add", "Microsoft.VisualStudio.Workload.VCTools",
        "--add", "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
        "--add", "Microsoft.VisualStudio.Component.Windows11SDK.22621",
        "--add", "Microsoft.VisualStudio.Component.VC.CMake.Project"
    ) -Wait
    
    Write-Host "Instalación completada!" -ForegroundColor Green
    Write-Host "Reinicia tu terminal y ejecuta 'flutter doctor' para verificar." -ForegroundColor Cyan
    
} catch {
    Write-Host "Error durante la descarga/instalación: $_" -ForegroundColor Red
    Write-Host "Descarga manual desde: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022" -ForegroundColor Yellow
}

Read-Host "Presiona Enter para continuar..."
