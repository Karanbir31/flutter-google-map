import 'package:flutter/material.dart';
import 'package:fluttergooglemap/home/controller/home_screen_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(title: Text("Home Screen")),

      body: Center(
        child: Obx(
          () => Text("Api Key from env file --> ${controller.apikey.value}"),
        ),
      ),
    );
  }
}
