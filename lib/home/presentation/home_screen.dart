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
        backgroundColor: theme.colorScheme.tertiaryContainer,
        foregroundColor: theme.colorScheme.onTertiaryContainer,
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shadowColor: theme.colorScheme.primary.withValues(alpha: 0.5),

        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 12),
            child: IconButton(
              onPressed: () async {
                debugPrint("PolyLine function call ");
                //await controller.drawPolylineUsingApi();
                controller.drawCircleOnMap();
              },
              icon: Icon(Icons.search, size: 32),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLocationPermissionDenied.value) {
            return Center(
              child: MaterialButton(
                onPressed: controller.checkAndRequestLocationPermission,
                child: const Text("Need location access"),
              ),
            );
          }

          return GoogleMap(
            onMapCreated: controller.onMapCreated,
            markers: controller.markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: controller.targetLatLng,
              zoom: 14.0,
            ),
            polylines: controller.polylines,
            circles: controller.mapCircles,

            myLocationEnabled: true,
            myLocationButtonEnabled: true,

            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            compassEnabled: true,

            onTap: controller.updateCurrentLocation,
          );
        }),
      ),
    );
  }
}
