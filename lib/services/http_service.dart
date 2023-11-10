import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  static const String _baseUrl = String.fromEnvironment('BASE_URL');

  static Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(Uri.parse('$_baseUrl$path'));

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String path, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    return _handleResponse(response);
  }

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
