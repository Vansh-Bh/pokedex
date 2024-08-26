import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  ThemeService() {
    isDarkMode.value = _loadThemeFromBox();
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(isDarkMode.value);
  }
}

class MyAppThemes {
  static final lightTheme = ThemeData(
    fontFamily: 'pokemon',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
  );

  static final darkTheme = ThemeData(
    fontFamily: 'pokemon',
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
  );
}
