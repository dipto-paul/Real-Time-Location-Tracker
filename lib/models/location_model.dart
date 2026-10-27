import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Model: holds one location reading of the user.
class LocationModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
  }

  LatLng toLatLng() => LatLng(latitude, longitude);

  @override
  String toString() => '$latitude, $longitude';
}
