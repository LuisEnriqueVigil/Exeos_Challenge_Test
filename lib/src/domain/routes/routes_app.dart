import 'package:exeos_network_challenge/src/domain/routes/routes_string.dart';
import 'package:exeos_network_challenge/src/presentation/auth/pin_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/pages/qr_scanner_screen.dart';
import 'package:flutter/material.dart';

class RoutesApp {

  static Map<String,WidgetBuilder> routesOfAppDefine = {
        RoutesName.splashScreen : (context)=> const PinScreen(),
        RoutesName.qrScannerScreen: (context) => const QrScannerScreen(),
        RoutesName.pinScreen: (context) => const PinScreen(),

  };
}