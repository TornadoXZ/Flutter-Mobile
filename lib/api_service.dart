// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models.dart';

class ApiService {
  static const String baseUrl = 'http://52.90.111.225:8081/api/cal/auth';

  // Guardar el accessToken en SharedPreferences
  Future<void> _saveToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
  }

  // Obtener el accessToken de SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Registro
  Future<AuthResponse> register(AuthRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: request.toJsonString(),
      );

      print('Register - Código de estado: ${response.statusCode}');
      print('Register - Respuesta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return AuthResponse.fromJson(responseData);
      } else {
        throw Exception('Error en registro: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en registro: $e');
      throw e;
    }
  }

  // Login
  Future<AuthResponse> login(AuthRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: request.toJsonString(),
      );

      print('Login - Código de estado: ${response.statusCode}');
      print('Login - Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(responseData);
        await _saveToken(authResponse.accessToken);
        return authResponse;
      } else {
        throw Exception('Error en login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en login: $e');
      throw e;
    }
  }

  // Petición autenticada
  Future<Map<String, dynamic>> fetchProtectedData() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token disponible');
    }

    try {
      final response = await http.get(
        Uri.parse('http://52.90.111.225:8081/api/cal/user/profile'), // Cambiado a un endpoint potencialmente real
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Protected - Código de estado: ${response.statusCode}');
      print('Protected - Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en petición protegida: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en petición protegida: $e');
      throw e;
    }
  }
}