import 'package:exeos_network_challenge/src/domain/controllers/coins/coins_controller.dart';
import 'package:exeos_network_challenge/src/presentation/coins/screen/crypto_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchCoinsWidgetOnCryptoListScreen extends StatelessWidget {
  const SearchCoinsWidgetOnCryptoListScreen({
    super.key,
    required TextEditingController searchController,
    required List<CryptoCurrency> filteredCryptos,
  }) : _searchController = searchController, _filteredCryptos = filteredCryptos;

  final TextEditingController _searchController;
  final List<CryptoCurrency> _filteredCryptos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value){
          context.read<CoinsController>().filterCryptos(
            filteredCryptos: _filteredCryptos,
            query: value,
          );
        },
        decoration: InputDecoration(
          hintText: 'Buscar criptomonedas...',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blue,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<CoinsController>().filterCryptos(
                      filteredCryptos: _filteredCryptos,
                      query: _searchController.text,
                    );
                  },
                )
              : null,
          filled: true,
          fillColor:Colors.blue.withAlpha(30)
    ,                  border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
