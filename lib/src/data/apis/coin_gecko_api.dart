import 'package:exeos_network_challenge/src/domain/models/currency_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../client/client_api.dart';

class CoinGeckoApi with ChangeNotifier {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  final ApiClient _apiClient = ApiClient();

  bool _loadingGetRequest = false;
  int _statusCodeGetRequest = 0; 

  bool get loadingGetRequest => _loadingGetRequest;
  set loadingGetRequest (bool valor){
    _loadingGetRequest = valor;
    notifyListeners();
  }

  int get statusCodeGetRequest => _statusCodeGetRequest;
  set statusCodeGetRequest (int valor){
    _statusCodeGetRequest = valor;
    notifyListeners();
  }

  CoinGeckoApi() {
    // Configurar el cliente para CoinGecko
    _apiClient.configure(
      baseUrl: _baseUrl,
      timeout: const Duration(seconds: 15),
    );
  }
 
  // Método genérico para hacer peticiones GET
  Future<List<CryptoCurrency>> getListCoinsWithValueVsCurrency({
    required String endpoint,
    required int perpage,
    required int page,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800), () {});
    loadingGetRequest = true; // Iniciar carga
    try {
      final url  = _apiClient.buildUrlWithParams(endpoint, {
        'vs_currency': 'usd',
        'per_page': 5,
        'page': 0,
      });
      _apiClient.setBearerToken("CG-5om8KsKynHcTsDR6SW4mhk33");

      debugPrint('CoinGecko GET: $url');

      final response = await _apiClient.client
          .get(
            Uri.parse(url),
            headers: _apiClient.headers,
          )
          .timeout(_apiClient.timeout);

      debugPrint('CoinGecko Response: ${response.statusCode}');
      statusCodeGetRequest = response.statusCode;
      
      if (response.statusCode == 200) {
        loadingGetRequest = false;
        notifyListeners();
        List<CryptoCurrency> listOfCurrency = cryptoCurrencyFromJson(response.body);
        return listOfCurrency;
      } else {
        loadingGetRequest = false;
        notifyListeners();
        debugPrint('Error CoinGecko: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      loadingGetRequest = false; 
      notifyListeners();
      debugPrint('Error en petición CoinGecko: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _apiClient.client.close();
    super.dispose();
  }
}