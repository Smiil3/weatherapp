import 'package:flutter/material.dart';
import '../data/weather_model.dart';
import '../../../core/constants/api_constants.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key, required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          data.cityName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Image.network(
          ApiConstants.iconUrl(data.icon),
          width: 80,
          height: 80,
        ),
        Text(
          '${data.temp.round()}°',
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
        Text(
          data.description.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _InfoChip(label: 'Ressenti', value: '${data.feelsLike.round()}°'),
            const SizedBox(width: 24),
            _InfoChip(label: 'Humidité', value: '${data.humidity}%'),
            const SizedBox(width: 24),
            _InfoChip(label: 'Vent', value: '${data.windSpeed.round()} m/s'),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        Text(value, style: const TextStyle(fontSize: 15, color: Colors.white)),
      ],
    );
  }
}
