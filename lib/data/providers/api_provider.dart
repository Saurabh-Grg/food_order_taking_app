import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';

class ApiProvider {
  final http.Client httpClient;

  // Constructor that optionally takes a custom HTTP client for testing
  ApiProvider({http.Client? client}) : httpClient = client ?? http.Client();

  // Base URL would come from your constants
  final String baseUrl = ApiConstants.baseUrl;

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await httpClient.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await httpClient.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await httpClient.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return json.decode(response.body);
    } else {
      throw Exception('Server error: ${response.statusCode} ${response.body}');
    }
  }
}