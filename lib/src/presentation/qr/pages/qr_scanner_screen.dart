import 'package:exeos_network_challenge/src/data/apis/coin_gecko_api.dart';
import 'package:exeos_network_challenge/src/domain/controllers/qr/qr_controller.dart';
import 'package:exeos_network_challenge/src/presentation/qr/pages/loading_qr_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/input_code_to_validate_widget_on_qr_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/label_container_of_use_scanner_widget_on_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/scanner_container_widget_on_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? scannedResult;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double boxHeigthBig =size.height * 0.03;
    final double boxHeigthSmall = size.height * 0.01;


    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,        
        automaticallyImplyLeading: false, //
        elevation: 2,
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: boxHeigthBig),
              // Header con icono principal
              ScannerContainerWidgetOnScannerScreen(),
              
              SizedBox(height: boxHeigthBig),
              
              // Descripción
              LabelContainerOfUseScannerWidgetOnScannerScreen(
                boxHeigthSmall: boxHeigthSmall
              ),
              
              SizedBox(height: boxHeigthBig),
              
              // Botón principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openQRScanner,
                  icon: const Icon(Icons.camera_alt, size: 24),
                  label: const Text(
                    'Abrir Scanner QR',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
              ),
              SizedBox(height: boxHeigthSmall),
              InputCodeToValidateWidgetOnQrScannerScreen(
                onChanged: (value){
                  context.read<QrControllers>().codeForSearchController = value;
                },
                onSearchPressed: (value) async {
                  if (value.isEmpty) {
                    _showErrorSnackBar('Por favor ingresa un código para buscar');
                    return;
                  }
                    // Obtener la instancia del CoinGeckoApi
                    final coinGeckoApi = CoinGeckoApi();
                    // Navegar a la pantalla de loading con la función de búsqueda real
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadingQrScannerScreen(
                          searchQuery: value,
                          searchFunction:coinGeckoApi.makeGetRequest('/simple/price?ids=bitcoin&vs_currencies=usd'), // Función de búsqueda real
                          onCancel: () => Navigator.pop(context, {'cancelled': true}),
                        ),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Informacion encontrada'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                },
              ),
                            
              SizedBox(height: boxHeigthBig),
              
              // Resultado del escaneo
              if (scannedResult != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[50]!, Colors.green[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'QR Escaneado Exitosamente',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Contenido:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: SelectableText(
                          scannedResult!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _copyToClipboard,
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text('Copiar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green[700],
                                side: BorderSide(color: Colors.green[300]!),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _clearResult,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Limpiar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(color: Colors.grey[300]!),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Método para abrir el scanner de cámara
  void _openQRScanner() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ),
      );
      
      if (result is String && result.isNotEmpty) {
        setState(() {
          scannedResult = result;
        });
        _showSuccessSnackBar('¡Código QR escaneado exitosamente!');
      }
    } catch (e) {
      _showErrorSnackBar('Error al abrir el scanner: ${e.toString()}');
    }
  }

  // Método para escanear desde imagen
  void _copyToClipboard() {
    if (scannedResult != null) {
      // Aquí implementarías copy to clipboard
      _showSuccessSnackBar('Código copiado al portapapeles');
    }
  }

  void _clearResult() {
    setState(() {
      scannedResult = null;
    });
    _showInfoSnackBar('Resultado limpiado');
  }

  void _showSuccessSnackBar(String message) {
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

  void _showErrorSnackBar(String message) {
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

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
