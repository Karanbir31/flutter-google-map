import 'package:flutter/cupertino.dart';
import 'package:fluttergooglemap/core/app_utils/permission_utils.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreenController extends GetxController {
  /// Google Map Controller
  GoogleMapController? googleMapController;
  final _location = Location();

  RxBool isLocationPermissionDenied = false.obs;

  /// Initial map position (default Chandigarh, India)
  LatLng locationLatLng = const LatLng(30.7333, 76.7794);

  /// Map markers
  final RxSet<Marker> markers = <Marker>{}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _addNewMarkerOnMap(locationLatLng);
    await _moveMapCamera(locationLatLng);
    // Request or check location permission
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

  /// Called when the map is created
  void onMapCreated(GoogleMapController mapController) {
    googleMapController = mapController;
  }

  /// Fetch current location and update map
  Future<void> _fetchCurrentLocation() async {
    try {

      final userLocation = await _location.getLocation();
      final userLatLng = LatLng(
        userLocation.latitude!,
        userLocation.longitude!,
      );

      await _moveMapCamera(userLatLng);
      _addNewMarkerOnMap(userLatLng);
    } catch (error) {
      debugPrint("Error accessing current location: $error");
    }
  }

  Future<void> _moveMapCamera(LatLng newLatLng) async {
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(target: newLatLng, zoom: 14.0),
    );
    await googleMapController?.moveCamera(cameraUpdate);
  }

  void _addNewMarkerOnMap(LatLng newLatLng) {
    markers.add(
      Marker(
        markerId: MarkerId(
          "newMarkId${newLatLng.latitude}${newLatLng.longitude}",
        ),
        position: newLatLng,
        infoWindow: InfoWindow(title: "on tab location"),
        onTap: () {
          _onClickMarker(newLatLng);
        },
      ),
    );
  }

  void updateLocationLatLng(LatLng newLatLng) {
    _moveMapCamera(newLatLng);
    _addNewMarkerOnMap(newLatLng);
  }

  void _onClickMarker(LatLng latLng) {

   // final selectedLocation = _location.


    Get.snackbar(
      "you click on marker",
      "mark location ${latLng.latitude}, ${latLng.longitude} ",
      backgroundColor: CupertinoColors.lightBackgroundGray,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      colorText: CupertinoColors.black,
    );
  }
}
