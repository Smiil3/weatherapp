import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/weather/data/weather_result.dart';
import '../constants/api_constants.dart';

class WeatherService {
  Future<WeatherResult> fetchAll(double lat, double lon) async {
    final params = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': ApiConstants.apiKey,
      'units': 'metric',
    };

    final results = await Future.wait([
      http.get(Uri.parse(ApiConstants.currentUrl).replace(queryParameters: params)),
      http.get(Uri.parse(ApiConstants.forecastUrl).replace(queryParameters: params)),
    ]);

    for (final r in results) {
      if (r.statusCode != 200) {
        throw Exception('Erreur API ${r.statusCode}: ${r.body}');
      }
    }

    return WeatherResult.fromTwoResponses(
      currentJson: jsonDecode(results[0].body) as Map<String, dynamic>,
      forecastJson: jsonDecode(results[1].body) as Map<String, dynamic>,
    );
  }
}
