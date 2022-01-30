//singleton class so we dont need to call UserSecureStorage from every screen

import 'package:my_login/user_secure_storage.dart';

class LoggedUserInfo {
  String? loggedUsername;
  String? loggedUserEmail;

  static final LoggedUserInfo _singleton = LoggedUserInfo._internal();

  factory LoggedUserInfo() {
    return _singleton;
  }

  LoggedUserInfo._internal();

  Future<void> iniLoggedUserInfo() async {
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();

    if (loggedUsername != null && loggedUserEmail!=null) {
      print("LoggedUserInfo singleton. persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
    }
    else {
      print("LoggedUserInfo singleton. no user logged");
    }
  }
}