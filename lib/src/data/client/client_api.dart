import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() {
    return _instance;
  }
  
  ApiClient._internal();

  // Configuración base
  static const String _defaultBaseUrl = 'https://api.coingecko.com/api/v3';
  static const Duration _defaultTimeout = Duration(seconds: 30);
  
  String _baseUrl = _defaultBaseUrl;
  String? _bearerToken;
  Duration _timeout = _defaultTimeout;
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Getters
  String get baseUrl => _baseUrl;
  String? get bearerToken => _bearerToken;
  Duration get timeout => _timeout;
  Map<String, String> get headers => _buildHeaders();

  // Configuración del cliente
  void configure({
    String? baseUrl,
    String? bearerToken,
    Duration? timeout,
    Map<String, String>? additionalHeaders,
  }) {
    if (baseUrl != null) _baseUrl = baseUrl;
    if (bearerToken != null) _bearerToken = bearerToken;
    if (timeout != null) _timeout = timeout;
    
    if (additionalHeaders != null) {
      _defaultHeaders.addAll(additionalHeaders);
    }    
    debugPrint('ApiClient configurado:');
    debugPrint('Base URL: $_baseUrl');
    debugPrint('Token: ${_bearerToken != null ? "Configurado" : "No configurado"}');
    debugPrint('Timeout: ${_timeout.inSeconds}s');
  }

  // Configurar token Bearer
  void setBearerToken(String token) {
    _bearerToken = token;
    debugPrint('Bearer token actualizado');
  }

  // Limpiar token
  void clearToken() {
    _bearerToken = null;
    debugPrint('Bearer token eliminado');
  }

  // Construir headers
  Map<String, String> _buildHeaders({Map<String, String>? additionalHeaders}) {
    final headers = Map<String, String>.from(_defaultHeaders);
    
    if (_bearerToken != null && _bearerToken!.isNotEmpty) {
      headers['x-cg-demo-api-key'] = '$_bearerToken';
      headers['accept'] ='application/json'; 
    }
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

  // Construir URL completa
  String buildUrl(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint; // URL absoluta
    }
    
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final cleanBaseUrl = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    
    return '$cleanBaseUrl/$cleanEndpoint';
  }

  // Construir URL con query parameters dinámicos
  String buildUrlWithParams(String endpoint, Map<String, dynamic>? queryParams) {
    String baseUrl = buildUrl(endpoint);
    
    if (queryParams?.isEmpty ?? true) return baseUrl;
    
    String queryString = queryParams!.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return queryString.isEmpty ? baseUrl : '$baseUrl?$queryString';
  }

  // Cliente HTTP para usar en otros servicios
  http.Client get client => http.Client();
}

