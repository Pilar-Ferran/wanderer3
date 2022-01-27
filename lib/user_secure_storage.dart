import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _flutterSecureStorage = FlutterSecureStorage();

  static const _keyUserEmail = 'user_email';
  static const _keyUsername = 'username';
  static const _keyIsLogged = 'is_logged';

  static Future setUserEmail(String email) async => await _flutterSecureStorage.write(key: _keyUserEmail, value: email);

  static Future<String?> getUserEmail() async => await _flutterSecureStorage.read(key: _keyUserEmail);

  static Future setUsername(String username) async => await _flutterSecureStorage.write(key: _keyUsername, value: username);

  static Future<String?> getUsername() async => await _flutterSecureStorage.read(key: _keyUsername);

  /*static Future setIsLogged(bool isLogged) async => await _flutterSecureStorage.write(key: _keyIsLogged, value: isLogged);

  static Future<bool?> getIsLogged() async => await _flutterSecureStorage.read(key: _keyIsLogged);*/
}