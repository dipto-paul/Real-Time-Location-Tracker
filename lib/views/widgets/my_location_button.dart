import 'package:flutter/material.dart';

/// Widget: floating button that re-centers the map on the user.
class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyLocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.my_location),
    );
  }
}
