

import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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

  // Método para abrir el scanner de cámara
  void openQRScanner(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ),
      );
      debugPrint("result: $result");
    } catch (e) {
      if(context.mounted){
        showErrorSnackBar(message: 'Error al abrir el scanner: ${e.toString()}',context: context);
      }
    }
  }

  

  void showSuccessSnackBar({required String message,required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  
  void showErrorSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _codeInputTextController.dispose();
    super.dispose();
  }
}