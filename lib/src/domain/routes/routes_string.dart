class RoutesName {
  static final RoutesName _routesName = RoutesName._internal();

  

  static const String splashScreen =  "/";
  static const String pinScreen = "/pin";
  static const String qrScannerScreen = "/qrScanner";
  
  factory RoutesName() {
    return _routesName;
  }
  
  RoutesName._internal();

}