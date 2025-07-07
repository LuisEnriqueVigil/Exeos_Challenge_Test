import 'dart:io';
import 'package:exeos_network_challenge/src/config/env_config.dart';
import 'package:exeos_network_challenge/src/data/apis/coin_gecko_api.dart';
import 'package:exeos_network_challenge/src/domain/controllers/auth/pin_controller.dart';
import 'package:exeos_network_challenge/src/domain/controllers/coins/coins_controller.dart';
import 'package:exeos_network_challenge/src/domain/controllers/qr/qr_controller.dart';
import 'package:exeos_network_challenge/src/domain/routes/routes_app.dart';
import 'package:exeos_network_challenge/src/domain/routes/routes_string.dart';
import 'package:exeos_network_challenge/src/windows/system_tray_manager.dart';
import 'package:exeos_network_challenge/src/windows/window_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  await EnvironmentBase.initEnvironment(); 
  WidgetsFlutterBinding.ensureInitialized();
  
  // Verificar si estamos en Windows y en modo tray
  if (Platform.isWindows) {
    // Si se ejecuta con argumento --tray, inicia el proceso de bandeja
    if (args.contains('--tray')) {
      await SystemTrayManager.initialize();
      return; // No ejecutar la UI principal
    }
    
    // Si es el proceso principal de UI, configurar la ventana
    await WindowConfig.initialize();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:  (_)=> CoinGeckoApi()),
        ChangeNotifierProvider(create: (_)=> PinController()),
        ChangeNotifierProvider(create: (_)=> QrControllers()),
        ChangeNotifierProvider(create: (_)=> CoinsController())
      ],
      child: MaterialApp(
        title: 'Exeos Scann',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: RoutesName.pinScreen,
        debugShowCheckedModeBanner: false,
        routes: RoutesApp.routesOfAppDefine,
      ),
    );
  }
}
