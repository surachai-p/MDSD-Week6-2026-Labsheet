/// Runtime configuration supplied when the app starts.
///
/// Example:
/// flutter run --dart-define=OPENWEATHER_API_KEY=your_key
class ApiConfig {
  const ApiConfig._();

  static const openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '',
  );
}
