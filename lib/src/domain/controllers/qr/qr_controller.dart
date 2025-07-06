

import 'package:flutter/widgets.dart';

class QrControllers with ChangeNotifier{
  TextEditingController _codeInputTextController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPinValid = false;
  String _codeForSearchController = '';


  TextEditingController get codeInputTextController => _codeInputTextController;
  set codeInputTextController (TextEditingController valor){
    _codeInputTextController = valor;
    notifyListeners();
  }

  GlobalKey<FormState> get formKey => _formKey;
  set formKey (GlobalKey<FormState> valor){
    _formKey = valor;
    notifyListeners();
  }

  bool get isPinValid => _isPinValid;
  set isPinValid (bool valor){
    _isPinValid = valor;
    notifyListeners();
  }

  String get codeForSearchController => _codeForSearchController;
  set codeForSearchController (String valor){
    _codeForSearchController = valor;
    notifyListeners();
  }


  void clearPin() {
    codeInputTextController.clear();
    isPinValid = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _codeInputTextController.dispose();
    super.dispose();
  }
}