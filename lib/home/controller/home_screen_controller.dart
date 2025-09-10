import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    as polyline_package;
import 'package:fluttergooglemap/core/app_utils/permission_utils.dart';
import 'package:fluttergooglemap/env/app_env.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'map_helper.dart';

class HomeScreenController extends GetxController {
  /// Google Map Controller
  GoogleMapController? googleMapController;
  static final myApiKey = Env.googleMapApiKey;

  final _location = Location();

  polyline_package.PolylinePoints polylinePoints =
      polyline_package.PolylinePoints(apiKey: myApiKey);

  RxBool isLocationPermissionDenied = false.obs;

  /// Initial map position (default Chandigarh, India)
  LatLng targetLatLng = const LatLng(30.7333, 76.7794);
  LatLng currentLocation = LatLng(43.7333, 86.7794);

  final targetLocationMarkerId = MarkerId("target_marker_id");
  final currentLocationMarkerId = MarkerId("current_location_marker_id");

  /// Map overlays
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxSet<Circle> mapCircles = <Circle>{}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _addMarker(
      targetLatLng,
      title: "Target Location",
      markerId: targetLocationMarkerId,
    );
    await _moveMapCamera(targetLatLng);
    checkAndRequestLocationPermission();
  }

  Future<void> checkAndRequestLocationPermission() async {
    if (!await PermissionUtils.isLocationPermissionGranted()) {
      final result = await PermissionUtils.requestLocationPermission();
      if (result) {
        _fetchCurrentLocation();
      } else {
        isLocationPermissionDenied.value = true;
      }
    } else {
      _fetchCurrentLocation();
    }
  }

  /// Map created callback
  void onMapCreated(GoogleMapController mapController) {
    googleMapController = mapController;
  }

  /// Get user location
  Future<void> _fetchCurrentLocation() async {
    try {
      final userLocation = await _location.getLocation();
      currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);

      await _moveMapCamera(currentLocation);
      _addMarker(
        currentLocation,
        title: "currentLocation",
        markerId: currentLocationMarkerId,
      );
    } catch (error) {
      debugPrint("Error accessing current location: $error");
    }
  }

  Future<void> updateCurrentLocation(LatLng newLatLng) async {
    currentLocation = newLatLng;
    await _moveMapCamera(currentLocation);

    // Remove old marker with the same ID if it exists
    markers.removeWhere((marker) => marker.markerId == currentLocationMarkerId);

    _addMarker(newLatLng, markerId: currentLocationMarkerId);
  }

  Future<void> _moveMapCamera(LatLng newLatLng) async {
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(target: newLatLng, zoom: 14.0),
    );
    await googleMapController?.moveCamera(cameraUpdate);
  }

  /// Add Marker
  void _addMarker(
    LatLng position, {
    String? title,
    required MarkerId markerId,
  }) {
    markers.add(
      MapHelper.createMarker(
        markerId: markerId,
        position,
        title: title,
        onTap: () {
          _onClickMarker(position);
        },
      ),
    );
  }

  /// Add Circle
  void drawCircleOnMap() {
    LatLng center = currentLocation;
    double radiusMeters = 1000;
    mapCircles
      ..clear()
      ..add(MapHelper.createCircle(center, radiusMeters));
  }

  /// Add Polyline manually
  void drawPolylineBetween(LatLng start, LatLng end) {
    polylines.add(MapHelper.createPolyline([start, end]));
  }

  /// On Marker Tap
  void _onClickMarker(LatLng latLng) {
    Get.snackbar(
      "Marker Clicked",
      "Location: ${latLng.latitude}, ${latLng.longitude}",
      backgroundColor: Colors.grey,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      colorText: Colors.black,
    );
  }

  /// TODO: Integrate Google Directions API (Routes) later
  Future<void> drawPolylineUsingApi() async {
    // Build request
    final request = polyline_package.RoutesApiRequest(
      origin: polyline_package.PointLatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      ),
      destination: polyline_package.PointLatLng(
        targetLatLng.latitude,
        targetLatLng.longitude,
      ),
      travelMode: polyline_package.TravelMode.driving,
    );

    // Call API
    final response = await polylinePoints.getRouteBetweenCoordinatesV2(
      request: request,
    );

    if (response.routes.isNotEmpty) {
      final route = response.routes.first;
      final points = route.polylinePoints ?? [];

      polylines.add(
        MapHelper.createPolyline(
          points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
        ),
      );
    }
  }
}
