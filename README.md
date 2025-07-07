# 🚀 Exeos Network - Crypto Scanner

Una aplicación Flutter multiplataforma para escanear códigos QR y consultar información de criptomonedas usando la API de CoinGecko.
PIN PARA ACCESO A APP: 2345
## 📱 Características

- **Scanner QR/Código de barras** para múltiples plataformas
- **Lista de criptomonedas** con precios 
- **Validación de códigos** con interfaz intuitiva
- **Arquitectura de dos procesos** para Windows (bandeja del sistema + UI)
- **Soporte multiplataforma**: Android, Windows

## 🛠️ Tecnologías y Paquetes Utilizados

### **Paquetes Principales:**
- `flutter` - Framework principal
- `http: ^1.2.0` - Cliente HTTP para peticiones a APIs
- `provider: ^6.1.2` - Gestión de estado reactivo
- `simple_barcode_scanner: ^0.3.0` - Scanner QR/códigos con soporte completo

### **Paquetes para Windows:**
- `system_tray: ^2.0.3` - Icono en bandeja del sistema
- `window_manager: ^0.3.7` - Gestión avanzada de ventanas
- `process_run: ^0.12.5` - Lanzamiento de procesos independientes

### **Paquetes de Desarrollo:**
- `flutter_lints: ^5.0.0` - Reglas de análisis de código
- `msix: ^3.16.7` - Empaquetado para Microsoft Store
- `permission_handler: ^11.3.1` - Gestión de permisos

## 🌐 API de CoinGecko

### **¿Qué es CoinGecko?**
CoinGecko es una de las APIs más confiables para obtener datos de criptomonedas en tiempo real.

### **Endpoint Principal Utilizado:**
```
GET https://api.coingecko.com/api/v3/coins/markets
```

### **Parámetros de consulta:**
- `vs_currency=usd` - Precios en dólares
- `per_page=50` - Cantidad de resultados por página
- `page=1` - Número de página
- `order=market_cap_desc` - Ordenar por capitalización de mercado

### **Datos obtenidos:**
- Nombre y símbolo de la criptomoneda
- Precio actual en USD
- Cambio porcentual en 24h
- Capitalización de mercado
- Imagen/logo de la criptomoneda

## ⚙️ Configuración Inicial

### **1. Requisitos del Sistema**

#### **Para todas las plataformas:**
- Flutter SDK 3.7.2 o superior
- Dart SDK incluido con Flutter

### **2. Configuración del archivo .env**

1. **El archivo `.env` ya está incluido en el proyecto** con la configuración básica.

2. **Edita el archivo `.env` en la raíz del proyecto:**
   ```env
   # URL base de la API
   API_BASE_URL=https://api.coingecko.com/api/v3
   
   # API Key (opcional para uso básico)
   COINGECKO_API_KEY=TU_API_KEY_AQUI
   ```

3. **Obtener API Key (opcional):**
   - Visita: https://www.coingecko.com/en/api
   - Regístrate para obtener una API key gratuita
   - Reemplaza `TU_API_KEY_AQUI` con tu clave real

### **3. Instalación de Dependencias**

# Instalar dependencias
flutter pub get

# Verificar configuración
flutter doctor
```

## 🚀 Compilación y Ejecución

### **Desarrollo (todas las plataformas):**

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en dispositivo específico
flutter run -d windows    # Para Windows
flutter run -d android    # Para Android
```

### **Para Windows - Aplicación Normal:**

```bash
# Build release estándar
flutter build windows --release

# El ejecutable estará en:
# build/windows/x64/runner/Release/exeos_network_challenge.exe
```

### **Para Windows - Arquitectura de Dos Procesos:**

#### **Opción 1: Script Automático**
```bash
# Ejecutar script de build
scripts\windows\build_two_processes.bat
```

#### **Opción 2: Build Manual**
```bash
# 1. Build proceso de bandeja
flutter build windows --target=lib/main_tray.dart --release

# 2. Copiar ejecutable de bandeja
copy build\windows\x64\runner\Release\exeos_network_challenge.exe dist\exeos_network_tray.exe

# 3. Build proceso de UI
flutter build windows --target=lib/main_ui.dart --release

# 4. Copiar ejecutable de UI
copy build\windows\x64\runner\Release\exeos_network_challenge.exe dist\exeos_network_ui.exe
```

### **Para Android:**

```bash
# Build APK
flutter build apk --release
```

## 🖥️ Uso en Windows (Dos Procesos)

### **Ejecución:**
1. Ejecutar `dist/exeos_network_tray.exe`
2. Aparece icono en la bandeja del sistema
3. Click derecho en el icono → "Mostrar UI"
4. Se abre la interfaz principal de la aplicación

### **Características especiales:**
- **Proceso de bandeja:** Permanece en segundo plano
- **Proceso de UI:** Se puede cerrar independientemente
- **Comunicación:** El proceso de bandeja controla el de UI

### **Error: "Permission denied for camera"**
- Verificar permisos de cámara en el dispositivo
- En Android: Configuración → Aplicaciones → Permisos

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada principal
├── main_ui.dart             # Punto de entrada para proceso UI (Windows)
├── main_tray.dart           # Punto de entrada para proceso bandeja (Windows)
├── src/
│   ├── data/
│   │   ├── apis/
│   │   │   └── coin_gecko_api.dart    # Cliente de CoinGecko API
│   │   └── client/
│   │       └── client_api.dart        # Cliente HTTP genérico
│   ├── domain/
│   │   ├── controllers/               # Controladores de estado
│   │   ├── models/                    # Modelos de datos
│   │   └── routes/                    # Configuración de rutas
│   ├── presentation/
│   │   └── qr/                        # Pantallas y widgets
        └── auth/                      # Pantallas y widgets
        └── coins/                     # Pantallas y widgets
│   └── windows/                       # Utilidades específicas Windows
│       ├── process_launcher.dart      # Lanzador de procesos
│       ├── system_tray_manager.dart   # Gestión de bandeja
│       └── window_config.dart         # Configuración de ventanas
```

---

**¡Desarrollado con ❤️ usando Flutter y la API de CoinGecko!**
