import 'package:exeos_network_challenge/src/data/apis/coin_gecko_api.dart';
import 'package:exeos_network_challenge/src/domain/controllers/qr/qr_controller.dart';
import 'package:exeos_network_challenge/src/presentation/qr/screen/loading_qr_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/button_open_scanner_widget_on_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/input_code_to_validate_widget_on_qr_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/label_container_of_use_scanner_widget_on_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/scanner_container_widget_on_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: GestureDetector(
        onTap: () {
          // Ocultar teclado cuando se toca fuera del input
          FocusScope.of(context).unfocus();
        },
        child: Padding(
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
              
              // Botón principal abrir el scanner
              ButtonOpenScannerWidgetOnScannerScreen(),

              SizedBox(height: boxHeigthSmall),
              
              InputCodeToValidateWidgetOnQrScannerScreen(
                onChanged: (value){
                  context.read<QrControllers>().codeForSearchController = value;
                },
                onSearchPressed: (value) async {
                    FocusScope.of(context).unfocus();
                    // Obtener la instancia del CoinGeckoApi
                    final coinGeckoApi = context.read<CoinGeckoApi>();
                    // Navegar a la pantalla de loading con la función de búsqueda real
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadingQrScannerScreen(
                          searchQuery: value,
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
                },
              ),
                            
              SizedBox(height: boxHeigthBig),
              
            
            ],
          ),
        ),
      ),
    )
    );
  }

  


}
