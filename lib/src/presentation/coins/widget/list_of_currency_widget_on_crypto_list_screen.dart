import 'package:exeos_network_challenge/src/domain/controllers/coins/coins_controller.dart';
import 'package:exeos_network_challenge/src/domain/models/currency_model.dart';
import 'package:exeos_network_challenge/src/presentation/coins/widget/crypto_card_widget_on_crypto_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfCurrencyWidgetOnCryptoListScreen extends StatelessWidget {
  final List<CryptoCurrency> listOfAllCryptos ;
  const ListOfCurrencyWidgetOnCryptoListScreen({
    required this.listOfAllCryptos,
    super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: listOfAllCryptos.length,
      itemBuilder: (context, index) {
        final crypto = listOfAllCryptos[index];
        return CryptoCardWidgetOnCryptoListScreen(
          crypto: crypto,
          onTap: () => context.read<CoinsController>().onCryptoTapped(crypto,context),
        );
      },
    );
  }
}