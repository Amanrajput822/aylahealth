import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _userIDPrefKey = 'user_id_pref_key';
  static const String _authTokenPrefKey = 'auth_token_pref_key';
  static const String _emailPrefKey = 'email_key';
  static const String _namePrefKey = 'name_key';
  static const String _profilePrefKey = 'profile_key';
  static const String _learningStatusKey = 'learningStatus_key';
  static const String _subscriptionStatusKey = 'subscriptionStatus_key';
  static const String _subscriptionCancelStatusKey = 'subscriptionCancelStatus_key';


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

/// learning status
  static String get learningStatus {
    return _prefs.getString(_learningStatusKey) ?? "";
  }

  static set learningStatus(String value) {
    _prefs.setString(_learningStatusKey, value);
  }

  /// learning status
  static bool get subscriptionStatus {
    return _prefs.getBool(_subscriptionStatusKey) ?? false;
  }

  static set subscriptionStatus(bool value) {
    _prefs.setBool(_subscriptionStatusKey, value);
  }

  /// learning status
  static int get subscriptionCancelStatus {
    return _prefs.getInt(_subscriptionCancelStatusKey) ?? 0;
  }

  static set subscriptionCancelStatus(int value) {
    _prefs.setInt(_subscriptionCancelStatusKey, value);
  }
}
