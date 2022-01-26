import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _flutterSecureStorage = FlutterSecureStorage();

  static const _keyUserEmail = 'user_email';

  static Future setUserEmail(String email) async => await _flutterSecureStorage.write(key: _keyUserEmail, value: email);

  static Future<String?> getUserEmail() async => await _flutterSecureStorage.read(key: _keyUserEmail);
}