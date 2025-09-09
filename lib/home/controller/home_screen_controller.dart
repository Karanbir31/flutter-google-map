import 'package:flutter/cupertino.dart';
import 'package:fluttergooglemap/core/app_utils/permission_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreenController extends GetxController {
  /// Google Map Controller
  GoogleMapController? googleMapController;

  /// Loading state
  RxBool isLoading = true.obs;

  /// Current device location
  Position? currentPosition;

  /// Initial map position (default Chandigarh, India)
  Rx<LatLng> initialLatLng = const LatLng(30.7333, 76.7794).obs;

  /// Map markers
  final Set<Marker> markers = {};

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;

    // Request or check location permission
    if (!await PermissionUtils.isLocationPermissionGranted()) {
      final result = await PermissionUtils.requestLocationPermission();
      if (result) {
        _fetchCurrentLocation();
      }
    } else {
      _fetchCurrentLocation();
    }
  }

  /// Called when the map is created
  void onMapCreated(GoogleMapController mapController) {
    googleMapController = mapController;
  }

  /// Fetch current location and update map
  Future<void> _fetchCurrentLocation() async {
    try {
      if (!await PermissionUtils.isLocationPermissionGranted()) return;

      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        debugPrint("Location services are disabled.");
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // initialLatLng.value = LatLng(
      //   currentPosition!.latitude,
      //   currentPosition!.longitude,
      // );
    } catch (error) {
      debugPrint("Error accessing current location: $error");
    } finally {
      // Always add/update marker and stop loading
      markers.add(
        Marker(
          markerId: const MarkerId('marker1'),
          position: initialLatLng.value,
          infoWindow: const InfoWindow(title: "Current Location"),
        ),
      );
      isLoading.value = false;
    }
  }
}
