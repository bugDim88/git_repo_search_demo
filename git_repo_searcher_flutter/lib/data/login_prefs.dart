import 'package:shared_preferences/shared_preferences.dart';

class LoginPrefs {
  static final _kToken = "token";

  Future<SharedPreferences> get _sharedPrefs async =>
      await SharedPreferences.getInstance();

  Future<String> getToken() async => (await _sharedPrefs).getString(_kToken);

  Future<void> setToken(String token) async =>
      (await _sharedPrefs).setString(_kToken, token);
}
