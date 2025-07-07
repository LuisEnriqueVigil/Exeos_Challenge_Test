import 'package:exeos_network_challenge/src/presentation/coins/screen/crypto_list_screen.dart';
import 'package:flutter/material.dart';


// Widget para cada card de criptomoneda
class CryptoCardWidgetOnCryptoListScreen extends StatelessWidget {
  final CryptoCurrency crypto;
  final VoidCallback onTap;

  const CryptoCardWidgetOnCryptoListScreen({
    super.key,
    required this.crypto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.priceChange >= 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de la criptomoneda
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(30),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    crypto.icon,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Información de la moneda
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        crypto.symbol,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Precio y cambio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${crypto.price.toStringAsFixed(crypto.price < 1 ? 3 : 2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive 
                            ? Colors.green.withAlpha(30)
                            : Colors.red.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.trending_up : Icons.trending_down,
                            size: 16,
                            color: isPositive ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isPositive ? '+' : ''}${crypto.priceChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isPositive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}