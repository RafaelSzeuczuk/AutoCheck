import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class VehicleService {
  Future<Vehicle> getVehicle(String placa) async {
    final token = dotenv.env['PLACAS_API_TOKEN']?.trim() ?? '';
    if (token.isEmpty) throw Exception('Configure o PLACAS_API_TOKEN no arquivo .env.');

    final response = await http.post(
      Uri.parse('https://placas.app.br/api/v1/placas/numero'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'placa': placa}),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Token da API de placas inválido ou sem autorização.');
    }
    if (response.statusCode == 404) {
      throw Exception('Placa não encontrada. Confira os caracteres digitados.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('A API de placas retornou o erro ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('A resposta da API não está no formato esperado.');
    }
    return Vehicle(decoded);
  }
}
