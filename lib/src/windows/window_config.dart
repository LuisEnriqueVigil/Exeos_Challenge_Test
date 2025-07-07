import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

class WindowConfig {
  /// Método estático para inicializar la configuración de ventana desde main
  static Future<void> initialize() async {
    await windowManager.ensureInitialized();
    
    // Verificar si es proceso UI o proceso principal
    // Por defecto configurar como UI si no se especifica lo contrario
    await setupUIWindow();
  }
  /// Configuración para el proceso principal (bandeja del sistema)
  static Future<void> setupMainWindow() async {
    const WindowOptions windowOptions = WindowOptions(
      size: Size(1, 1),                    // Ventana mínima (casi invisible)
      center: false,
      backgroundColor: Colors.transparent,
      skipTaskbar: true,                   // No mostrar en barra de tareas
      titleBarStyle: TitleBarStyle.hidden, // Sin barra de título
      windowButtonVisibility: false,       // Sin botones de ventana
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.hide();          // Ocultar inmediatamente
      await windowManager.setSkipTaskbar(true);
      await windowManager.setPreventClose(true); // Prevenir cierre accidental
    });
  }
  
  /// Configuración para el proceso de interfaz de usuario
  static Future<void> setupUIWindow() async {
    const WindowOptions windowOptions = WindowOptions(
      size: Size(1200, 800),               // Tamaño apropiado para la UI
      minimumSize: Size(800, 600),         // Tamaño mínimo
      center: true,
      backgroundColor: Colors.white,
      skipTaskbar: false,                  // Mostrar en barra de tareas
      titleBarStyle: TitleBarStyle.normal,
      title: 'Exeos Network - Crypto Scanner',
      windowButtonVisibility: true,        // Mostrar botones de ventana
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setSkipTaskbar(false);
    });
  }

  /// Configuración para ventana de desarrollo/debug
  static Future<void> setupDebugWindow() async {
    const WindowOptions windowOptions = WindowOptions(
      size: Size(1000, 700),
      center: true,
      backgroundColor: Colors.white,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Exeos Network - Debug Mode',
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /// Oculta la ventana actual
  static Future<void> hideWindow() async {
    try {
      await windowManager.hide();
    } catch (e) {
      debugPrint('Error al ocultar ventana: $e');
    }
  }

  /// Muestra la ventana actual
  static Future<void> showWindow() async {
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (e) {
      debugPrint('Error al mostrar ventana: $e');
    }
  }

  /// Minimiza la ventana a la bandeja del sistema
  static Future<void> minimizeToTray() async {
    try {
      await windowManager.hide();
      await windowManager.setSkipTaskbar(true);
    } catch (e) {
      debugPrint('Error al minimizar a bandeja: $e');
    }
  }

  /// Restaura la ventana desde la bandeja del sistema
  static Future<void> restoreFromTray() async {
    try {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setSkipTaskbar(false);
    } catch (e) {
      debugPrint('Error al restaurar desde bandeja: $e');
    }
  }
}
