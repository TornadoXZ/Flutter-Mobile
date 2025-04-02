// lib/models.dart
import 'dart:convert';

class AuthRequest {
  final String email;
  final String password;

  AuthRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  String toJsonString() => jsonEncode(toJson());
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
    );
  }
}