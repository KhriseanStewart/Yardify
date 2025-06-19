import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Storage instance with optional Android encryption options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  
  // Save a token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Read a token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Delete the token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Clear all secure storage (dangerous operation)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
