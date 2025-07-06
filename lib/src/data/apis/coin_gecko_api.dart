import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../client/client_api.dart';

class CoinGeckoApi with ChangeNotifier {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  final ApiClient _apiClient = ApiClient();

  bool _loadingGetRequest = false;

  bool get loadingGetRequest => _loadingGetRequest;
  set loadingGetRequest (bool valor){
    _loadingGetRequest = valor;
    notifyListeners();
  }

  CoinGeckoApi() {
    // Configurar el cliente para CoinGecko
    _apiClient.configure(
      baseUrl: _baseUrl,
      timeout: const Duration(seconds: 15),
      additionalHeaders: {
        'User-Agent': 'ExeosNetworkApp/1.0',
      },
    );
  }
 
  // Método genérico para hacer peticiones GET
  Future<dynamic> makeGetRequest(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 800), () {});
    loadingGetRequest = true; // Iniciar carga
    try {
      final url = _apiClient.buildUrl(endpoint);
      debugPrint('CoinGecko GET: $url');

      final response = await _apiClient.client
          .get(
            Uri.parse(url),
            headers: _apiClient.headers,
          )
          .timeout(_apiClient.timeout);

      debugPrint('CoinGecko Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        loadingGetRequest = false;
        notifyListeners();
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        loadingGetRequest = false;
        notifyListeners();
        debugPrint('Error CoinGecko: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      loadingGetRequest = false; 
      notifyListeners();
      debugPrint('Error en petición CoinGecko: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _apiClient.client.close();
    super.dispose();
  }
}