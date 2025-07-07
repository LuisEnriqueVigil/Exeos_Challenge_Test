# Build script for Exeos Network - Windows Two Process Architecture
# PowerShell version

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Building Exeos Network - Windows Version" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Create dist directory
Write-Host ""
Write-Host "[1/4] Limpiando builds anteriores..." -ForegroundColor Yellow
if (Test-Path "build\windows") {
    Remove-Item "build\windows" -Recurse -Force
}
if (Test-Path "dist") {
    Remove-Item "dist" -Recurse -Force
}
New-Item -ItemType Directory -Path "dist" -Force | Out-Null

# Build tray process
Write-Host ""
Write-Host "[2/4] Construyendo proceso de bandeja (main_tray.dart)..." -ForegroundColor Yellow
& flutter build windows --target=lib/main_tray.dart --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo al construir proceso de bandeja" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar..."
    exit 1
}

Write-Host ""
Write-Host "Copiando ejecutable de bandeja..." -ForegroundColor Green
Copy-Item "build\windows\x64\runner\Release\exeos_network_challenge.exe" "dist\exeos_network_tray.exe"

# Build UI process
Write-Host ""
Write-Host "[3/4] Construyendo proceso de UI (main_ui.dart)..." -ForegroundColor Yellow
& flutter build windows --target=lib/main_ui.dart --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo al construir proceso de UI" -ForegroundColor Red
    Read-Host "Presiona Enter para continuar..."
    exit 1
}

Write-Host ""
Write-Host "Copiando ejecutable de UI..." -ForegroundColor Green
Copy-Item "build\windows\x64\runner\Release\exeos_network_challenge.exe" "dist\exeos_network_ui.exe"

# Copy necessary files
Write-Host ""
Write-Host "[4/4] Copiando archivos necesarios..." -ForegroundColor Yellow
if (Test-Path "build\windows\x64\runner\Release\data") {
    Copy-Item "build\windows\x64\runner\Release\data" "dist\data" -Recurse
}

if (Test-Path "assets\icons") {
    if (-not (Test-Path "dist\assets\icons")) {
        New-Item -ItemType Directory -Path "dist\assets\icons" -Force | Out-Null
    }
    Copy-Item "assets\icons\*" "dist\assets\icons" -Recurse
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Build completado exitosamente!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Archivos generados en 'dist/':" -ForegroundColor White
Write-Host "- exeos_network_tray.exe (Proceso de bandeja)" -ForegroundColor Cyan
Write-Host "- exeos_network_ui.exe   (Proceso de UI)" -ForegroundColor Cyan
Write-Host ""
Write-Host "INSTRUCCIONES DE USO:" -ForegroundColor Yellow
Write-Host "1. Ejecutar 'exeos_network_tray.exe' como proceso principal" -ForegroundColor White
Write-Host "2. El icono aparecera en la bandeja del sistema" -ForegroundColor White
Write-Host "3. Click derecho -> 'Mostrar UI' para abrir la interfaz" -ForegroundColor White
Write-Host ""
Read-Host "Presiona Enter para continuar..."
