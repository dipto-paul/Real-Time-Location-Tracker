import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/location_tracker_controller.dart';
import '../../utils/constants.dart';

/// Widget: the Google Map itself.
class TrackerMap extends StatelessWidget {
  final LocationTrackerController controller;

  const TrackerMap({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: AppConstants.initialCameraPosition,
      markers: controller.markers,
      polylines: controller.polylines,
      zoomControlsEnabled: true,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: controller.onMapCreated,
    );
  }
}
