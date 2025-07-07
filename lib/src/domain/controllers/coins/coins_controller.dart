import 'package:exeos_network_challenge/src/domain/models/currency_model.dart';
import 'package:flutter/material.dart';

class CoinsController with ChangeNotifier{
  List<CryptoCurrency> _allCryptos = [];

  List<CryptoCurrency> get allCryptos => _allCryptos;
  set allCryptos (List<CryptoCurrency> valor){
    _allCryptos = valor;
    notifyListeners();
  }

  void filterCryptos({required String query, required List<CryptoCurrency> filteredCryptos}) {
      if (query.isEmpty) {
        filteredCryptos = List.from(_allCryptos);
      } else {
        filteredCryptos = _allCryptos.where((crypto) {
          return crypto.name.toLowerCase().contains(query.toLowerCase()) ||
                 crypto.symbol.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
  }

   void onCryptoTapped(CryptoCurrency crypto,BuildContext context) {
    // Aquí puedes navegar a una pantalla de detalles o mostrar más información
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 400),
        content: Text('Seleccionaste ${crypto.name}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}