import 'package:exeos_network_challenge/src/domain/controllers/coins/coins_controller.dart';
import 'package:exeos_network_challenge/src/domain/models/currency_model.dart';
import 'package:exeos_network_challenge/src/presentation/coins/widget/empty_state_list_crypto_currenci_widget.dart';
import 'package:exeos_network_challenge/src/presentation/coins/widget/list_of_currency_widget_on_crypto_list_screen.dart';
import 'package:exeos_network_challenge/src/presentation/coins/widget/return_to_options_scanner_widget_on_crypo_list_screen.dart';
import 'package:exeos_network_challenge/src/presentation/coins/widget/return_to_scanner_qr_widget_on_crypto_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    List<CryptoCurrency> listOfAllCryptos = context.watch<CoinsController>().allCryptos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          // Ocultar teclado cuando se toca fuera del buscador
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Lista de criptomonedas
           Expanded(
             child: listOfAllCryptos.isEmpty
                 ? EmptyStateListCryptoCurrenciWidget()
                 : ListOfCurrencyWidgetOnCryptoListScreen(
                  listOfAllCryptos: listOfAllCryptos
                )
           ),
           ReturnToScannerQrWidgetOnCryptoListScreen(),
           ReturnToOptionsScannerWidgetOnCrypoListScreen()
          ],
        ),
      ),
    );
  }

  

 
}
