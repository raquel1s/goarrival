import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static Future<LatLng?> getCoordinates(String city) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=1');

    try {
      final response = await http.get(url, headers: {'User-Agent': 'goarrival_app'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (e) {
      print('Erro na geocodificação: $e');
    }
    return null;
  }
}