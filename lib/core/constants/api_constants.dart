class ApiConstants {
  static const currentUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  static const iconBaseUrl = 'https://openweathermap.org/img/wn';
  static const apiKey = String.fromEnvironment('OWM_API_KEY');

  static String iconUrl(String icon) => '$iconBaseUrl/$icon@2x.png';
}
