
import 'package:exeos_network_challenge/src/data/apis/coin_gecko_api.dart';
import 'package:exeos_network_challenge/src/presentation/qr/screen/loading_qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    CoinGeckoApi coinGeckoApi = Provider.of<CoinGeckoApi>(context,listen: false);
    try {
      final result =  await SimpleBarcodeScanner.scanBarcode(
     context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Escanear QR',
        centerTitle: true,
        enableBackButton: true,
      ),
      isShowFlashIcon: true,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
    );
    
    debugPrint("QR Result: $result");
    if (result is String && result != '-1') {
      debugPrint("QR Result: $result");
      // Procesar resultado exitoso
      _codeForSearchController = result;      
      notifyListeners();
      if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Informacion encontrada'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
      if(context.mounted){
       await Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => LoadingQrScannerScreen(
             searchQuery: _codeForSearchController,
             searchFunction:coinGeckoApi.getListCoinsWithValueVsCurrency(
               endpoint:'/coins/markets',
               perpage: 5,
               page: 0
             ), // Función de búsqueda real
             onCancel: () => Navigator.pop(context, {'cancelled': true}),
           ),
         ),
       );
       if(context.mounted){
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Informacion encontrada'),
               backgroundColor: Colors.green,
               behavior: SnackBarBehavior.floating,
             ),
           );
       }
      }
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnackBar(
        message: 'Error al abrir el scanner: ${e.toString()}',
        context: context,
      );
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