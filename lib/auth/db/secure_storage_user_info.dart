import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageServiceUserInfo {
  // Storage instance with optional Android encryption options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  
  // Save email and password
  Future<void> saveUser(String email, String password) async {
    await _storage.write(key: 'auth_email', value: email);
    await _storage.write(key: 'auth_password', value: password);
  }

  // Get email
  Future<String?> getEmail() async {
    return await _storage.read(key: 'auth_email');
  }

  // Get password
  Future<String?> getPassword() async {
    return await _storage.read(key: 'auth_password');
  }

  // Get both email and password
  Future<Map<String, String?>?> getUserCredentials() async {
    final email = await _storage.read(key: 'auth_email');
    final password = await _storage.read(key: 'auth_password');
    if (email == null || password == null) {
      return null;
    }
    return {
      'email': email,
      'password': password,
    };
  }

  // Delete the token (assuming you mean delete email and password)
  Future<void> deleteUser() async {
    await _storage.delete(key: 'auth_email');
    await _storage.delete(key: 'auth_password');
  }

  // Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}