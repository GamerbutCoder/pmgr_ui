import 'package:shared_preferences/shared_preferences.dart';

const TOKEN_KEY = 'access_token';
const REFRESH_TOKEN_KEY = 'refresh_token';

Future<void> saveData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> storeToken(token) async {
  return await saveData(TOKEN_KEY, token);
}

Future<void> storeRefreshToken(token) async {
  return await saveData(REFRESH_TOKEN_KEY, token);
}

Future<String?> getToken() async {
  return await getData(TOKEN_KEY);
}

Future<bool> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(TOKEN_KEY);
}


Future<bool> clearRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(REFRESH_TOKEN_KEY);
}