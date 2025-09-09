import 'package:flutter/material.dart';
import 'package:fluttergooglemap/home/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadGoogleMapsApiKey();

    final theme = context.theme;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: SizedBox(
                width: 100,
                height: 100,

                child: CircularProgressIndicator(color: Colors.grey),
              ),
            );
          } else {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: controller.initialLatLng.value,
                zoom: 10.0,
              ),
            );
          }
        }),
      ),
    );
  }
}
