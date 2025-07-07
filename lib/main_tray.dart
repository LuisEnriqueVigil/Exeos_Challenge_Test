import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'src/windows/system_tray_manager.dart';
import 'src/windows/window_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar ventana principal (oculta para bandeja)
  await windowManager.ensureInitialized();
  await WindowConfig.setupMainWindow();
  
  // Inicializar system tray directamente
  await SystemTrayManager.initialize();
  
  // No necesitamos ejecutar runApp para el proceso de bandeja
  // El sistema queda ejecutándose en segundo plano
}
