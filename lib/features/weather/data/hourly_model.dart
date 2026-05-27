class HourlyForecast {
  final DateTime time;
  final double temp;
  final String icon;
  final int pop; // probabilité de précipitation (0-100)

  const HourlyForecast({
    required this.time,
    required this.temp,
    required this.icon,
    required this.pop,
  });

  // json = item de /data/2.5/forecast list[]
  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0] as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (main['temp'] as num).toDouble(),
      icon: weather['icon'] as String,
      pop: (((json['pop'] as num?) ?? 0) * 100).round(),
    );
  }
}
