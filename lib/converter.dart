/// Available conversion types.
enum ConversionType {
  celsiusToFahrenheit('Celsius to Fahrenheit (°C → °F)', '°F'),
  fahrenheitToCelsius('Fahrenheit to Celsius (°F → °C)', '°C');

  const ConversionType(this.label, this.resultUnit);

  /// Text shown in the dropdown.
  final String label;

  /// Unit appended to the converted value.
  final String resultUnit;
}

/// Pure conversion logic (easy to unit test).
class TemperatureConverter {
  /// F = (C × 9/5) + 32
  static double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;

  /// C = (F − 32) × 5/9
  static double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;

  static double convert(double value, ConversionType type) {
    switch (type) {
      case ConversionType.celsiusToFahrenheit:
        return celsiusToFahrenheit(value);
      case ConversionType.fahrenheitToCelsius:
        return fahrenheitToCelsius(value);
    }
  }
}
