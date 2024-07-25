// // shared_preferences_util.dart

// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesUtil {
//   static const String tokenKey = 'userToken';

//   static Future<void> saveToken(String token) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(tokenKey, token);
//   }

//   Future<String?> getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(tokenKey);
//   }

//   Future<void> clearToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove(tokenKey);
//   }
// }