import 'package:exeos_network_challenge/src/presentation/coins/screen/crypto_list_screen.dart';
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
}