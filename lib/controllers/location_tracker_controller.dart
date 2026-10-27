import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location_model.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';

/// Controller: all the logic (timer, markers, polyline, camera).
/// The View listens to this class and rebuilds when it calls notifyListeners().
class LocationTrackerController extends ChangeNotifier {
  LocationTrackerController({LocationService? locationService})
      : _locationService = locationService ?? LocationService();

  final LocationService _locationService;

  GoogleMapController? _mapController;
  Timer? _timer;
  bool _disposed = false;

  final List<LocationModel> _history = [];

  LocationModel? currentLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String? errorMessage;

  // ---------------- Map ----------------

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // If location arrived before the map was ready
    if (currentLocation != null) {
      _animateTo(currentLocation!);
    }
  }

  Future<void> goToCurrentLocation() async {
    if (currentLocation != null) {
      await _animateTo(currentLocation!);
    }
  }

  Future<void> _animateTo(LocationModel location) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location.toLatLng(),
          zoom: AppConstants.userZoom,
        ),
      ),
    );
  }

  // ---------------- Tracking ----------------

  Future<void> startTracking() async {
    try {
      await _locationService.ensurePermission();
    } on LocationException catch (e) {
      _setError(e.message);
      return;
    }

    // Fetch immediately, then every 10 seconds
    await _fetchLocation();
    _timer?.cancel();
    _timer = Timer.periodic(AppConstants.updateInterval, (_) => _fetchLocation());
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      if (_disposed) return;

      currentLocation = location;
      _history.add(location);
      _updateMarker(location);
      _updatePolyline();
      notifyListeners();

      await _animateTo(location);
    } catch (e) {
      _setError('Could not get location: $e');
    }
  }

  // ---------------- Marker & Polyline ----------------

  void _updateMarker(LocationModel location) {
    markers = {
      Marker(
        markerId: const MarkerId(AppConstants.markerId),
        position: location.toLatLng(),
        infoWindow: InfoWindow(
          title: AppConstants.infoWindowTitle,
          snippet: '${location.latitude}, ${location.longitude}',
        ),
      ),
    };
  }

  /// Connects every previous location to the current one.
  void _updatePolyline() {
    polylines = {
      Polyline(
        polylineId: const PolylineId(AppConstants.polylineId),
        points: _history.map((l) => l.toLatLng()).toList(),
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  // ---------------- Errors ----------------

  void _setError(String message) {
    errorMessage = message;
    if (!_disposed) notifyListeners();
  }

  void clearError() {
    errorMessage = null;
  }

  @override
  void dispose() {
    _disposed = true;
    stopTracking();
    _mapController?.dispose();
    super.dispose();
  }
}
