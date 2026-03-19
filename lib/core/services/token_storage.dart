import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _kToken = 'access_token';
  static const _kExp = 'access_token_exp_utc';

  Future<void> saveToken(String token, DateTime expiresAtUtc) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kToken, token);
    await sp.setString(_kExp, expiresAtUtc.toIso8601String());
  }

  Future<String?> readToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kToken);
  }

  Future<DateTime?> readExpiry() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_kExp);
    return v == null ? null : DateTime.tryParse(v);
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kToken);
    await sp.remove(_kExp);
  }
}