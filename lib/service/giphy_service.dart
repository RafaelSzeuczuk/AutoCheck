import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GiphyService {
  Future<Map<String, dynamic>?> getGif(String search) async {
    final key = dotenv.env['GIPHY_API_KEY']?.trim() ?? '';
    if (key.isEmpty) throw Exception('Configure o GIPHY_API_KEY no arquivo .env.');

    final uri = Uri.https('api.giphy.com', '/v1/gifs/search', {
      'api_key': key,
      'q': search,
      'limit': '1',
      'rating': 'g',
      'lang': 'en',
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('A API de GIFs retornou o erro ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final gifs = decoded['data'] as List<dynamic>? ?? [];
    return gifs.isEmpty ? null : gifs.first as Map<String, dynamic>;
  }
}
