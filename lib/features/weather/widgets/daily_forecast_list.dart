import 'package:flutter/material.dart';
import '../data/daily_model.dart';
import '../../../core/constants/api_constants.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.days});

  final List<DailyForecast> days;

  static const _dayNames = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];

  String _dayLabel(DateTime date, int index) {
    if (index == 0) return "Aujourd'hui";
    return _dayNames[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRÉVISIONS 7 JOURS',
            style: TextStyle(fontSize: 11, color: Colors.white54, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          ...days.asMap().entries.map(
            (e) => _DailyRow(
              day: e.value,
              label: _dayLabel(e.value.date, e.key),
              isLast: e.key == days.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  const _DailyRow({
    required this.day,
    required this.label,
    required this.isLast,
  });

  final DailyForecast day;
  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              Image.network(ApiConstants.iconUrl(day.icon), width: 28, height: 28),
              const Spacer(),
              Text(
                '${day.tempMin.round()}°',
                style: const TextStyle(fontSize: 15, color: Colors.white54),
              ),
              const SizedBox(width: 8),
              _TempBar(min: day.tempMin, max: day.tempMax),
              const SizedBox(width: 8),
              Text(
                '${day.tempMax.round()}°',
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
      ],
    );
  }
}

class _TempBar extends StatelessWidget {
  const _TempBar({required this.min, required this.max});

  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [
            Color.lerp(Colors.blue, Colors.orange, (min + 20) / 60)!,
            Color.lerp(Colors.blue, Colors.orange, (max + 20) / 60)!,
          ],
        ),
      ),
    );
  }
}
