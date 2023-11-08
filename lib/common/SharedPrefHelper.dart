import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _userIDPrefKey = 'user_id_pref_key';
  static const String _authTokenPrefKey = 'auth_token_pref_key';
  static const String _emailPrefKey = 'email_key';
  static const String _namePrefKey = 'name_key';
  static const String _profilePrefKey = 'profile_key';

  SharedPrefHelper._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ///userid
  static int? get userId {
    return _prefs.getInt(_userIDPrefKey);
  }

  static set userId(int? value) {
    if (value != null) {
      _prefs.setInt(_userIDPrefKey, value);
    } else {
      _prefs.remove(_userIDPrefKey);
    }
  }

  static String get email {
    return _prefs.getString(_emailPrefKey) ?? "";
  }

  static set email(String value) {
    _prefs.setString(_emailPrefKey, value);
  }

  static String get profile {
    return _prefs.getString(_profilePrefKey) ?? "";
  }
  static set profile(String value) {
    _prefs.setString(_profilePrefKey, value);
  }
  ///isLogged in
  static bool get isLoggedIn {
    return userId != null;
  }


  ///auth token
  static String get authToken {
    return _prefs.getString(_authTokenPrefKey) ?? "";
  }

  static set authToken(String value) {
    _prefs.setString(_authTokenPrefKey, value);
  }


  ///auth token


  static String get name {
    return _prefs.getString(_namePrefKey) ?? "";
  }

  static set name(String value) {
    _prefs.setString(_namePrefKey, value);
  }

}
