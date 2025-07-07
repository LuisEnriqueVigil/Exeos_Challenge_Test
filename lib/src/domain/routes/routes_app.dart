import 'package:exeos_network_challenge/src/domain/routes/routes_string.dart';
import 'package:exeos_network_challenge/src/presentation/auth/screen/pin_screen.dart';
import 'package:exeos_network_challenge/src/presentation/coins/screen/crypto_list_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/screen/qr_scanner_screen.dart';
import 'package:flutter/material.dart';

class RoutesApp {

  static Map<String,WidgetBuilder> routesOfAppDefine = {
        RoutesName.splashScreen : (context)=> const PinScreen(),
        RoutesName.qrScannerScreen: (context) => const QrScannerScreen(),
        RoutesName.pinScreen: (context) => const PinScreen(),
        RoutesName.cryptoListScreen : (context)=> const CryptoListScreen()

  };
}