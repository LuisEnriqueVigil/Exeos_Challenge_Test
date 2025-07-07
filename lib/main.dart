import 'package:exeos_network_challenge/src/data/apis/coin_gecko_api.dart';
import 'package:exeos_network_challenge/src/domain/controllers/auth/pin_controller.dart';
import 'package:exeos_network_challenge/src/domain/controllers/coins/coins_controller.dart';
import 'package:exeos_network_challenge/src/domain/controllers/qr/qr_controller.dart';
import 'package:exeos_network_challenge/src/domain/routes/routes_app.dart';
import 'package:exeos_network_challenge/src/domain/routes/routes_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
