import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const List<String> _endpoints = [
    'https://c21.com.bo/v/resultados/tipo_casa-o-casa-en-condominio/operacion_venta?json=true',
    'https://c21.com.bo/v/resultados/tipo_departamento/operacion_venta?json=true',
    'https://c21.com.bo/v/resultados/tipo_terreno/operacion_venta?json=true',
  ];

  static Future<List<Map<String, dynamic>>> fetchAllProperties() async {
    final allResults = <Map<String, dynamic>>[];
    final seenIds = <String>{};

    for (final endpoint in _endpoints) {
      try {
        final response = await http
            .get(
              Uri.parse(endpoint),
              headers: {'Accept': 'application/json'},
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final results = data['results'] as List? ?? [];
          for (final item in results) {
            final id = item['id']?.toString() ?? '';
            if (id.isNotEmpty && seenIds.add(id)) {
              allResults.add(item as Map<String, dynamic>);
            }
          }
        }
      } catch (_) {}
    }

    return allResults;
  }
}
