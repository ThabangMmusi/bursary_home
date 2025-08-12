import 'package:shared_preferences/shared_preferences.dart';
import 'package:bursary_home_ui/enums.dart'; // Add this import

class ThemePreferences {
  static const _themeKey = 'theme_type';

  Future<ThemeType> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    if (themeString == ThemeType.provider.toString()) {
      return ThemeType.provider;
    } else {
      return ThemeType.student;
    }
  }

  Future<void> saveTheme(ThemeType themeType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeType.toString());
  }
}
