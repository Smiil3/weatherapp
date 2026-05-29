import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  static const _apiKey = '055e78f2005f9e43d2031b711a8973d8';

  Future<String> fetchTemperature(String city) async {
    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode} - ${response.reasonPhrase}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['main']['temp'].toString();
  }

  Future<Map<String, String>> fetchTemperatureByLocation(double latitude, double longitude) async {
    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode} - ${response.reasonPhrase}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return {
      'city': data['name'].toString(),
      'temperature': data['main']['temp'].toString(),
    };
  }

  Future<Map<String, dynamic>> fetchWeatherDetails(String city) async {
    // Use the 5-day/3-hour forecast endpoint directly and aggregate to daily.
    final forecastUri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/forecast',
      {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    final forecastResponse = await http.get(forecastUri);
    if (forecastResponse.statusCode != 200) {
      final body = forecastResponse.body;
      throw Exception('Error: ${forecastResponse.statusCode} - ${forecastResponse.reasonPhrase}. Response: $body');
    }

    final forecastData = jsonDecode(forecastResponse.body) as Map<String, dynamic>;
    final cityName = (forecastData['city'] != null && forecastData['city']['name'] != null)
        ? forecastData['city']['name'].toString()
        : city;
    final List list = (forecastData['list'] as List);

    final Map<String, Map<String, dynamic>> byDate = {};
    for (final item in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as num).toInt() * 1000).toUtc();
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      final temp = (item['main']['temp'] as num).toDouble();
      final icon = (item['weather'] as List)[0]['icon'].toString();

      if (!byDate.containsKey(key)) {
        byDate[key] = {'min': temp, 'max': temp, 'icon': icon, 'dt': dt};
      } else {
        final cur = byDate[key]!;
        if (temp < (cur['min'] as double)) cur['min'] = temp;
        if (temp > (cur['max'] as double)) cur['max'] = temp;
      }
    }

    final daily = byDate.values
        .toList()
        .map((m) => {
              'dt': (m['dt'] as DateTime).millisecondsSinceEpoch ~/ 1000,
              'temp': {'min': (m['min'] as double), 'max': (m['max'] as double)},
              'weather': [ {'icon': m['icon']} ],
            })
        .take(7)
        .toList();

    final String currentTemp = list.isNotEmpty
        ? ((list[0]['main'] != null && list[0]['main']['temp'] != null)
            ? list[0]['main']['temp'].toString()
            : '')
        : '';
    final String currentIcon = list.isNotEmpty
        ? ((list[0]['weather'] as List).isNotEmpty ? (list[0]['weather'][0]['icon'].toString()) : '')
        : '';

    return {
      'city': cityName,
      'temperature': currentTemp,
      'icon': currentIcon,
      'forecast': daily
          .map(
            (item) => {
              'day': DateTime.fromMillisecondsSinceEpoch((item['dt'] as num).toInt() * 1000).weekday,
              'min': ((item['temp'] as Map<String, dynamic>)['min'] ?? '').toString(),
              'max': ((item['temp'] as Map<String, dynamic>)['max'] ?? '').toString(),
              'icon': (item['weather'] as List)[0]['icon'].toString(),
            },
          )
          .toList(),
    };
  }
}

