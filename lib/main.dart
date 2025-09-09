import 'package:flutter/material.dart';
import 'package:fluttergooglemap/core/theme/app_theme.dart';
import 'package:fluttergooglemap/home/controller/home_screen_controller.dart';
import 'package:get/get.dart';

import 'home/presentation/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = ThemeData.light().textTheme;
    final myTheme = MyApplicationMaterialTheme(textTheme);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onInit: () {
        Get.lazyPut(() => HomeScreenController());
      },

      theme: myTheme.light(),
      darkTheme: myTheme.dark(),

      home: HomeScreen(),
    );
  }
}
