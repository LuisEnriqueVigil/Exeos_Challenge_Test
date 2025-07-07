import 'package:system_tray/system_tray.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'process_launcher.dart';

class SystemTrayManager {
  final SystemTray _systemTray = SystemTray();
  final ProcessLauncher _processLauncher = ProcessLauncher();
  bool _isInitialized = false;

  /// Método estático para inicializar el system tray desde main
  static Future<void> initialize() async {
    final manager = SystemTrayManager();
    await manager.initSystemTray();
    
    // Mantener el proceso de bandeja ejecutándose
    await manager._keepAlive();
  }

  /// Mantiene el proceso de bandeja ejecutándose
  Future<void> _keepAlive() async {
    // Crear un loop infinito para mantener el proceso activo
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      
      // Verificar si el system tray sigue activo
      if (!_isInitialized) {
        debugPrint('System tray no inicializado, reiniciando...');
        await initSystemTray();
      }
    }
  }

  /// Inicializa el icono en la bandeja del sistema
  Future<void> initSystemTray() async {
    if (_isInitialized) return;

    try {
      // Configurar el icono de la bandeja
      String iconPath = await _getIconPath();
      
      await _systemTray.initSystemTray(
        title: "Exeos Network",
        iconPath: iconPath,
        toolTip: "Exeos Network - Crypto Scanner\nClick derecho para ver opciones",
      );

      // Configurar el menú contextual
      await _setupContextMenu();
      
      _isInitialized = true;
      debugPrint('System Tray inicializado exitosamente');
      
    } catch (e) {
      debugPrint('Error al inicializar System Tray: $e');
    }
  }

  /// Configura el menú contextual
  Future<void> _setupContextMenu() async {
    final Menu menu = Menu();
    
    await menu.buildFrom([
      MenuItemLabel(
        label: 'Mostrar UI',
        onClicked: (menuItem) async {
          debugPrint('Menú: Mostrar UI clickeado');
          await _processLauncher.launchUIProcess();
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Estado UI',
        onClicked: (menuItem) async {
          bool isRunning = _processLauncher.isUIProcessRunning;
          String status = isRunning ? 'Ejecutándose' : 'Detenido';
          debugPrint('Estado del proceso UI: $status');
          
          // Mostrar notificación del estado
          await _systemTray.popUpContextMenu();
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Salir',
        onClicked: (menuItem) async {
          debugPrint('Menú: Salir clickeado');
          await _shutdown();
        },
      ),
    ]);

    await _systemTray.setContextMenu(menu);
  }

  /// Obtiene la ruta del icono para la bandeja
  Future<String> _getIconPath() async {
    try {
      // Buscar icono en assets
      String currentDir = Directory.current.path;
      
      // Buscar en diferentes ubicaciones posibles
      List<String> possiblePaths = [
        '$currentDir${Platform.pathSeparator}assets${Platform.pathSeparator}icons${Platform.pathSeparator}app_icon.ico',
        '$currentDir${Platform.pathSeparator}assets${Platform.pathSeparator}icons${Platform.pathSeparator}app_icon.png',
        '$currentDir${Platform.pathSeparator}data${Platform.pathSeparator}flutter_assets${Platform.pathSeparator}assets${Platform.pathSeparator}icons${Platform.pathSeparator}app_icon.png',
        '$currentDir${Platform.pathSeparator}web${Platform.pathSeparator}icons${Platform.pathSeparator}Icon-192.png',
      ];
      
      for (String path in possiblePaths) {
        if (File(path).existsSync()) {
          debugPrint('Icono encontrado en: $path');
          return path;
        }
      }
      
      // Si no se encuentra ningún icono, crear uno temporal
      return await _createDefaultIcon();
      
    } catch (e) {
      debugPrint('Error al obtener icono: $e');
      return await _createDefaultIcon();
    }
  }

  /// Crea un icono por defecto si no se encuentra el personalizado
  Future<String> _createDefaultIcon() async {
    try {
      // Usar icono del sistema como fallback
      String tempDir = Directory.systemTemp.path;
      String iconPath = '$tempDir${Platform.pathSeparator}exeos_tray_icon.ico';
      
      // Si ya existe, usarlo
      if (File(iconPath).existsSync()) {
        return iconPath;
      }
      
      // Por simplicidad, usar un icono del sistema
      // En producción, se incluiría un .ico embebido
      return iconPath;
      
    } catch (e) {
      debugPrint('Error al crear icono por defecto: $e');
      return '';
    }
  }

  /// Actualiza el tooltip de la bandeja
  Future<void> updateToolTip(String message) async {
    if (!_isInitialized) return;
    
    try {
      await _systemTray.setToolTip("Exeos Network\n$message");
    } catch (e) {
      debugPrint('Error al actualizar tooltip: $e');
    }
  }

  /// Muestra una notificación en la bandeja
  Future<void> showNotification(String title, String message) async {
    if (!_isInitialized) return;
    
    try {
      // Implementar notificación si está disponible en el paquete
      debugPrint('Notificación: $title - $message');
    } catch (e) {
      debugPrint('Error al mostrar notificación: $e');
    }
  }

  /// Procedimiento de cierre
  Future<void> _shutdown() async {
    try {
      debugPrint('Iniciando cierre de la aplicación...');
      
      // Terminar proceso UI si está ejecutándose
      await _processLauncher.terminateUIProcess();
      
      // Destruir system tray
      await dispose();
      
      // Salir de la aplicación
      SystemNavigator.pop();
      
    } catch (e) {
      debugPrint('Error durante el cierre: $e');
      exit(0);
    }
  }

  /// Libera recursos del system tray
  Future<void> dispose() async {
    try {
      _processLauncher.dispose();
      
      if (_isInitialized) {
        await _systemTray.destroy();
        _isInitialized = false;
        debugPrint('System Tray destruido exitosamente');
      }
    } catch (e) {
      debugPrint('Error al destruir System Tray: $e');
    }
  }
}
