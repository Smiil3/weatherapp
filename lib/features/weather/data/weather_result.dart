import 'weather_model.dart';
import 'hourly_model.dart';
import 'daily_model.dart';

class WeatherResult {
  final WeatherData current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const WeatherResult({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherResult.fromTwoResponses({
    required Map<String, dynamic> currentJson,
    required Map<String, dynamic> forecastJson,
  }) {
    final list = forecastJson['list'] as List<dynamic>;
    return WeatherResult(
      current: WeatherData.fromJson(currentJson),
      hourly: list
          .take(24)
          .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: DailyForecast.fromForecastList(list),
    );
  }
}
