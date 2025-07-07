import 'dart:io';
import 'package:flutter/foundation.dart';

class ProcessLauncher {
  Process? _uiProcess;
  
  /// Lanza el proceso de la interfaz de usuario
  Future<void> launchUIProcess() async {
    // Verificar si ya existe un proceso UI ejecutándose
    if (_uiProcess != null) {
      try {
        // Verificar si el proceso sigue vivo
        bool isAlive = !_uiProcess!.kill(ProcessSignal.sigusr1);
        if (isAlive) {
          debugPrint('Proceso UI ya está ejecutándose');
          return;
        }
      } catch (e) {
        // El proceso ya no existe
        _uiProcess = null;
      }
    }

    try {
      // Obtener la ruta del directorio actual
      String currentDir = Directory.current.path;
      String uiExecutable = '$currentDir${Platform.pathSeparator}exeos_network_ui.exe';
      
      // Verificar si el ejecutable existe
      if (!File(uiExecutable).existsSync()) {
        debugPrint('Ejecutable UI no encontrado en: $uiExecutable');
        await _launchWithFlutter();
        return;
      }
      
      // Lanzar el proceso UI
      _uiProcess = await Process.start(
        uiExecutable,
        [],
        mode: ProcessStartMode.detached,
        workingDirectory: currentDir,
      );
      
      debugPrint('Proceso UI lanzado exitosamente - PID: ${_uiProcess!.pid}');
      
      // Escuchar cuando el proceso termine
      _uiProcess!.exitCode.then((exitCode) {
        debugPrint('Proceso UI terminó con código: $exitCode');
        _uiProcess = null;
      });
      
    } catch (e) {
      debugPrint('Error al lanzar proceso UI: $e');
      await _launchWithFlutter();
    }
  }
  
  /// Método de respaldo para lanzar con Flutter en modo desarrollo
  Future<void> _launchWithFlutter() async {
    try {
      debugPrint('Intentando lanzar con Flutter...');
      
      _uiProcess = await Process.start(
        'flutter',
        [
          'run',
          '-d', 'windows',
          '-t', 'lib/main_ui.dart',
          '--release'
        ],
        mode: ProcessStartMode.detached,
        workingDirectory: Directory.current.path,
      );
      
      debugPrint('Proceso UI lanzado con Flutter - PID: ${_uiProcess!.pid}');
      
    } catch (e) {
      debugPrint('Error al lanzar con Flutter: $e');
    }
  }
  
  /// Verifica si el proceso UI está ejecutándose
  bool get isUIProcessRunning {
    if (_uiProcess == null) return false;
    
    try {
      // Enviar señal 0 para verificar si el proceso existe
      bool isAlive = !_uiProcess!.kill(ProcessSignal.sigusr1);
      if (!isAlive) {
        _uiProcess = null;
      }
      return isAlive;
    } catch (e) {
      _uiProcess = null;
      return false;
    }
  }
  
  /// Termina el proceso UI si está ejecutándose
  Future<void> terminateUIProcess() async {
    if (_uiProcess != null) {
      try {
        _uiProcess!.kill(ProcessSignal.sigterm);
        await _uiProcess!.exitCode;
        debugPrint('Proceso UI terminado exitosamente');
      } catch (e) {
        debugPrint('Error al terminar proceso UI: $e');
      } finally {
        _uiProcess = null;
      }
    }
  }
  
  /// Libera recursos
  void dispose() {
    _uiProcess?.kill(ProcessSignal.sigkill);
    _uiProcess = null;
  }
}