import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  AppConstants._();

  static const String appTitle = 'Real-Time Location Tracker';
  static const String infoWindowTitle = 'My current location';

  /// Location update interval
  static const Duration updateInterval = Duration(seconds: 10);

  /// Camera zoom level when following the user
  static const double userZoom = 17;

  /// Fallback camera position (Dhaka) until the first location is found
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14,
  );

  static const String markerId = 'current_location';
  static const String polylineId = 'route';
}
