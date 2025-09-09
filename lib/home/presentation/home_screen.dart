import 'package:flutter/material.dart';
import 'package:fluttergooglemap/home/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(color: Colors.grey),
              ),
            );
          }

          return GoogleMap(
            onMapCreated: controller.onMapCreated,
            markers: controller.markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: controller.initialLatLng.value,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        }),
      ),
    );
  }
}
