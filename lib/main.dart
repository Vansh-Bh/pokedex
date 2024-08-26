import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex/home.dart';
import 'package:pokedex/theme_changer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService());

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PokeDex',
          themeMode: themeService.theme,
          theme: MyAppThemes.lightTheme,
          darkTheme: MyAppThemes.darkTheme,
          home: HomeScreen(),
        ));
  }
}
