import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentBase {
  static initEnvironment() async {
    await dotenv.load(fileName: ".env");
    // La línea de print podría eliminarse en producción o reemplazarse por un logger
    debugPrint("Entorno inicializado: $apiUrl");
  }

  // Variables que son sensibles o cambian por entorno
  static String get apiUrl =>
      dotenv.env['API_BASE_URL'] ?? 'No esta configurado el API_URL';
  static String get apiKey =>
      dotenv.env['COINGECKO_API_KEY'] ?? 'No esta API_KEY configurada';
  static String get duration =>
      dotenv.env['API_TIMEOUT'] ?? 'Timeout no configurada';

}
