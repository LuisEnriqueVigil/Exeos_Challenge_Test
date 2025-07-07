@echo off
echo ==========================================
echo Building Exeos Network - Windows Version
echo ==========================================

echo.
echo [1/4] Limpiando builds anteriores...
if exist "build\windows" rmdir /s /q "build\windows"
if exist "dist" rmdir /s /q "dist"
mkdir dist

echo.
echo [2/4] Construyendo proceso de bandeja (main_tray.dart)...
call flutter build windows --target=lib/main_tray.dart --release
if %ERRORLEVEL% neq 0 (
    echo ERROR: Fallo al construir proceso de bandeja
    pause
    exit /b 1
)

echo.
echo Copiando ejecutable de bandeja...
copy "build\windows\x64\runner\Release\exeos_network_challenge.exe" "dist\exeos_network_tray.exe"

echo.
echo [3/4] Construyendo proceso de UI (main_ui.dart)...
call flutter build windows --target=lib/main_ui.dart --release
if %ERRORLEVEL% neq 0 (
    echo ERROR: Fallo al construir proceso de UI
    pause
    exit /b 1
)

echo.
echo Copiando ejecutable de UI...
copy "build\windows\x64\runner\Release\exeos_network_challenge.exe" "dist\exeos_network_ui.exe"

echo.
echo [4/4] Copiando archivos necesarios...
if exist "build\windows\x64\runner\Release\data" (
    xcopy "build\windows\x64\runner\Release\data" "dist\data" /E /I /Y
)

if exist "assets\icons" (
    if not exist "dist\assets\icons" mkdir "dist\assets\icons"
    xcopy "assets\icons" "dist\assets\icons" /E /I /Y
)

echo.
echo ==========================================
echo Build completado exitosamente!
echo ==========================================
echo.
echo Archivos generados en 'dist/':
echo - exeos_network_tray.exe (Proceso de bandeja)
echo - exeos_network_ui.exe   (Proceso de UI)
echo.
echo INSTRUCCIONES DE USO:
echo 1. Ejecutar 'exeos_network_tray.exe' como proceso principal
echo 2. El icono aparecera en la bandeja del sistema
echo 3. Click derecho -> "Mostrar UI" para abrir la interfaz
echo.
pause
