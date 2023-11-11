import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/";

  // HTTP get method
  static Future<Map<String, dynamic>> get(String path) async {
    try {
      _checkConnectivity();

      final response = await http.get(Uri.parse('$_baseUrl$path'));

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // HTTP post method
  static Future<Map<String, dynamic>> post(String path, dynamic data) async {
    try {
      _checkConnectivity();

      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _checkConnectivity() async {
    // Check for internet connectivity
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
  }

  // Handler for response
  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response) async {
    final Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      // Successful response
      return responseBody;
    } else {
      // Handle error response
      throw Exception(
          'HTTP ${response.statusCode}: ${responseBody['message']}');
    }
  }
}
