import 'package:geolocator/geolocator.dart';

import '../models/location_model.dart';

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}

/// Service: talks to the Geolocator plugin (permissions + GPS).
class LocationService {
  /// Checks GPS and permission. Throws [LocationException] if not usable.
  Future<void> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
          'Location service is disabled. Please turn on GPS.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
          'Location permission permanently denied. Enable it from settings.');
    }
  }

  /// Gets the current device location once.
  Future<LocationModel> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LocationModel.fromPosition(position);
  }
}
