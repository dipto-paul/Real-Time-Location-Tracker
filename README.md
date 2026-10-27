# Real-Time Location Tracker (Flutter)

Google Maps + Geolocator assignment.

## Setup
1. Open `android/app/src/main/AndroidManifest.xml` and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your Google Maps API key (Maps SDK for Android must be enabled).
2. Run `flutter pub get`
3. Run on a real device or emulator (set a location in emulator Extended Controls).

## Features
- Map smoothly animates to the user's current location
- Location fetched every 10 seconds, marker updates
- Polyline connects previous and current locations
- Tap marker -> info window: "My current location" + lat/lng snippet

## Project Structure (MVC)
```
lib/
├── main.dart                         # Entry point
├── app.dart                          # MaterialApp setup
├── models/
│   └── location_model.dart           # M: location data (lat, lng, time)
├── views/
│   ├── screens/
│   │   └── home_screen.dart          # V: Home screen
│   └── widgets/
│       ├── tracker_map.dart          # V: Google Map widget
│       └── my_location_button.dart   # V: Re-center button
├── controllers/
│   └── location_tracker_controller.dart  # C: timer, marker, polyline, camera logic
├── services/
│   └── location_service.dart         # Geolocator permission + GPS
└── utils/
    └── constants.dart                # Title, interval, zoom, ids
```
