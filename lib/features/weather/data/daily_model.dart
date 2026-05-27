class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;
  final int pop;

  const DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
    required this.pop,
  });

  // Agrège les tranches 3h de /data/2.5/forecast par jour
  static List<DailyForecast> fromForecastList(List<dynamic> list) {
    final Map<String, List<Map<String, dynamic>>> byDay = {};

    for (final item in list) {
      final json = item as Map<String, dynamic>;
      final date = DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);
      final key = '${date.year}-${date.month}-${date.day}';
      byDay.putIfAbsent(key, () => []).add(json);
    }

    return byDay.entries.take(7).map((entry) {
      final items = entry.value;
      final temps = items
          .map((e) => (e['main'] as Map)['temp'] as num)
          .toList();
      final midday = items.firstWhere(
        (e) {
          final h = DateTime.fromMillisecondsSinceEpoch(
              (e['dt'] as int) * 1000).hour;
          return h >= 11 && h <= 14;
        },
        orElse: () => items[items.length ~/ 2],
      );
      final weather = (midday['weather'] as List)[0] as Map<String, dynamic>;
      final maxPop = items
          .map((e) => (e['pop'] as num?) ?? 0)
          .reduce((a, b) => a > b ? a : b);

      return DailyForecast(
        date: DateTime.fromMillisecondsSinceEpoch((items[0]['dt'] as int) * 1000),
        tempMin: temps.reduce((a, b) => a < b ? a : b).toDouble(),
        tempMax: temps.reduce((a, b) => a > b ? a : b).toDouble(),
        icon: weather['icon'] as String,
        description: weather['description'] as String,
        pop: (maxPop * 100).round(),
      );
    }).toList();
  }
}
