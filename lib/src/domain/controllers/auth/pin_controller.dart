

import 'package:flutter/widgets.dart';

class PinController with ChangeNotifier{
  TextEditingController _pinController = TextEditingController();
  bool _isPinValid = false;
  String _pinInput = '';


  TextEditingController get pinController => _pinController;
  set pinController (TextEditingController valor){
    _pinController = valor;
    notifyListeners();
  }


  bool get isPinValid => _isPinValid;
  set isPinValid (bool valor){
    _isPinValid = valor;
    notifyListeners();
  }

  String get pinInput => _pinInput;
  set pinInput (String valor){
    _pinInput = valor;
    notifyListeners();
  }


  void clearPin() {
    pinController.clear();
    isPinValid = false;
    notifyListeners();
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }
}