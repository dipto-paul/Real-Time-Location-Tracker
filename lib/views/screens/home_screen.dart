import 'package:flutter/material.dart';

import '../../controllers/location_tracker_controller.dart';
import '../../utils/constants.dart';
import '../widgets/my_location_button.dart';
import '../widgets/tracker_map.dart';

/// View: Home screen. Only shows UI, all logic is in the controller.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocationTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LocationTrackerController();
    _controller.addListener(_showErrorIfAny);
    _controller.startTracking();
  }

  void _showErrorIfAny() {
    final message = _controller.errorMessage;
    if (message != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      _controller.clearError();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_showErrorIfAny);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appTitle)),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => TrackerMap(controller: _controller),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.currentLocation == null) {
            return const SizedBox.shrink();
          }
          return MyLocationButton(onPressed: _controller.goToCurrentLocation);
        },
      ),
    );
  }
}
