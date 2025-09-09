import 'package:flutter/cupertino.dart';
import 'package:fluttergooglemap/core/app_utils/permission_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../env/app_env.dart';

class HomeScreenController extends GetxController {
  RxString apikey = "NA".obs;

  RxBool isLoading = true.obs;
  Position? currentPosition;
  Rx<LatLng> initialLatLng = LatLng(45.521563, -122.677433).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;

    if (!await PermissionUtils.isLocationPermissionGranted()) {
      final result = await PermissionUtils.requestLocationPermission();
      if (result) {
        _currentLocation();
      }
    } else {
      _currentLocation();
    }
  }

  void loadGoogleMapsApiKey() {
    apikey.value = Env.googleMapApiKey;
    Get.snackbar("title", "message");
  }

  Future<void> _currentLocation() async {
    try {
      if (!await PermissionUtils.isLocationPermissionGranted()) return;

      bool isServiceEnable = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnable) {
        debugPrint("HomeScreenController isLocationServiceEnabled is false ");
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      initialLatLng.value = LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      isLoading.value = false;
    } catch (error) {
      debugPrint(
        "HomeScreenController error in access user current location $error ",
      );
    }
  }
}
