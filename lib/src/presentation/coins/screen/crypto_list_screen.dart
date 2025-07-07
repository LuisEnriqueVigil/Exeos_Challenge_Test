import 'package:exeos_network_challenge/src/presentation/coins/widget/crypto_card_widget_on_crypto_list_screen.dart';
import 'package:exeos_network_challenge/src/presentation/coins/widget/search_coins_widget_on_crypto_list_screen.dart';
import 'package:flutter/material.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CryptoCurrency> _allCryptos = [];
  List<CryptoCurrency> _filteredCryptos = [];

  @override
  void initState() {
    super.initState();
    _loadCryptoData();
    _filteredCryptos = _allCryptos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Datos simulados de criptomonedas
  void _loadCryptoData() {
    _allCryptos = [
      CryptoCurrency(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'BTC',
        price: 43250.00,
        priceChange: 2.45,
        icon: Icons.currency_bitcoin,
      ),
      CryptoCurrency(
        id: 'ethereum',
        name: 'Ethereum',
        symbol: 'ETH',
        price: 2650.00,
        priceChange: -1.23,
        icon: Icons.diamond,
      ),
      CryptoCurrency(
        id: 'binancecoin',
        name: 'BNB',
        symbol: 'BNB',
        price: 315.50,
        priceChange: 0.85,
        icon: Icons.monetization_on,
      ),
      CryptoCurrency(
        id: 'cardano',
        name: 'Cardano',
        symbol: 'ADA',
        price: 0.485,
        priceChange: 3.12,
        icon: Icons.account_balance,
      ),
      CryptoCurrency(
        id: 'solana',
        name: 'Solana',
        symbol: 'SOL',
        price: 98.75,
        priceChange: -2.18,
        icon: Icons.wb_sunny,
      ),
      CryptoCurrency(
        id: 'polkadot',
        name: 'Polkadot',
        symbol: 'DOT',
        price: 7.25,
        priceChange: 1.67,
        icon: Icons.scatter_plot,
      ),
      CryptoCurrency(
        id: 'chainlink',
        name: 'Chainlink',
        symbol: 'LINK',
        price: 14.85,
        priceChange: -0.45,
        icon: Icons.link,
      ),
      CryptoCurrency(
        id: 'litecoin',
        name: 'Litecoin',
        symbol: 'LTC',
        price: 72.30,
        priceChange: 1.98,
        icon: Icons.flash_on,
      ),
    ];
    _filteredCryptos = List.from(_allCryptos);
  }

  

  @override
  Widget build(BuildContext context) {
    
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
            // Buscador
            SearchCoinsWidgetOnCryptoListScreen(
              searchController: _searchController, 
              filteredCryptos: _filteredCryptos
            ),

            // Lista de criptomonedas
            Expanded(
              child: _filteredCryptos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredCryptos.length,
                      itemBuilder: (context, index) {
                        final crypto = _filteredCryptos[index];
                        return CryptoCardWidgetOnCryptoListScreen(
                          crypto: crypto,
                          onTap: () => _onCryptoTapped(crypto),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron criptomonedas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _onCryptoTapped(CryptoCurrency crypto) {
    // Aquí puedes navegar a una pantalla de detalles o mostrar más información
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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


// Modelo de datos para las criptomonedas
class CryptoCurrency {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double priceChange;
  final IconData icon;

  CryptoCurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.priceChange,
    required this.icon,
  });
}
