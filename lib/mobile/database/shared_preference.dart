import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String _boolKey = 'marketApp';

  // Save a boolean value
  static Future<void> saveBool(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_boolKey, value);
  }

  // Retrieve the boolean value
  static Future<bool?> getBool() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_boolKey);
  }

  // Optional: Remove the value
  static Future<void> removeBool() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_boolKey);
  }
}

class IsDarkTheme {
  static const String _boolKey = 'darkTheme';

  // Save a boolean value
  static Future<void> saveBool(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_boolKey, value);
  }

  // Retrieve the boolean value
  static Future<bool> getBool() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_boolKey) ?? false;
  }
}

class LocationPreference{
    static const String _boolKey = 'location_data';

  // Save a boolean value
  static Future<void> saveBool(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_boolKey, value);
  }

  // Retrieve the boolean value
  static Future<bool> getBool() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_boolKey) ?? false;
  }
}