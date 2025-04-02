// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  final String token;

  HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String decodedData = 'Presiona el botón para cargar los datos del token';

  void decodeToken() {
    try {
      // Decodificar el token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      // Convertir el payload a una cadena legible
      String formattedData = decodedToken.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
      setState(() {
        decodedData = formattedData;
      });
    } catch (e) {
      setState(() {
        decodedData = 'Error al decodificar el token: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Inicio de sesión exitoso!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              decodedData,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: decodeToken,
              child: Text('Cargar datos protegidos'),
            ),
          ],
        ),
      ),
    );
  }
}