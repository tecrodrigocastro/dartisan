import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferência de tema — root singleton (ver core_module.dart), mesmo padrão
/// ValueNotifier + persistência do AppSession/TokenStorage. Default escuro:
/// é o tema pensado pro produto, claro é só um fallback.
class ThemeController extends ValueNotifier<ThemeMode> {
  static const _prefsKey = 'dartisan.theme_mode';

  SharedPreferences? _prefs;

  ThemeController() : super(ThemeMode.dark) {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    final saved = prefs.getString(_prefsKey);
    if (saved == 'light') value = ThemeMode.light;
  }

  Future<void> toggle() async {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value == ThemeMode.dark ? 'dark' : 'light');
  }
}
