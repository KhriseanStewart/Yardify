import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveLoginCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> userPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin');
  }

  Future<void> setBiometricEnable(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }
}
