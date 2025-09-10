import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
  /// Create a marker
  static Marker createMarker(
      LatLng position, {
        required MarkerId markerId,
        String? title,
        VoidCallback? onTap,
      }) {
    return Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: title ?? "Marker"),
      onTap: onTap,
    );
  }



  /// Create a circle
  static Circle createCircle(
      LatLng center,
      double radiusMeters, {
        Color strokeColor = Colors.red,
        Color fillColor = Colors.redAccent,
      }) {
    return Circle(
      circleId: CircleId("circle_${center.latitude}_${center.longitude}"),
      center: center,
      radius: radiusMeters,
      strokeColor: strokeColor,
      fillColor: fillColor.withValues(alpha: 0.3),
      strokeWidth: 2,
    );
  }

  /// Create a polyline
  static Polyline createPolyline(
      List<LatLng> points, {
        Color color = Colors.deepOrange,
        int width = 4,
      }) {
    return Polyline(
      polylineId: PolylineId("polyline_${DateTime.now().millisecondsSinceEpoch}"),
      points: points,
      color: color,
      width: width,
    );
  }
}
