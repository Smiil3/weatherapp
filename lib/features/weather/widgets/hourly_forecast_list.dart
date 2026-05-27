import 'package:flutter/material.dart';
import '../data/hourly_model.dart';
import '../../../core/constants/api_constants.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({super.key, required this.hours});

  final List<HourlyForecast> hours;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'PRÉVISIONS HORAIRES',
              style: TextStyle(fontSize: 11, color: Colors.white54, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: hours.length,
              itemBuilder: (context, index) => _HourlyItem(hour: hours[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyItem extends StatelessWidget {
  const _HourlyItem({required this.hour});

  final HourlyForecast hour;

  String _formatHour(DateTime time) {
    final now = DateTime.now();
    if (time.hour == now.hour && time.day == now.day) return 'Maint.';
    return '${time.hour}h';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatHour(hour.time),
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          Image.network(ApiConstants.iconUrl(hour.icon), width: 32, height: 32),
          Text(
            '${hour.temp.round()}°',
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
