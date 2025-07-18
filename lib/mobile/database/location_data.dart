import 'dart:async';

import 'package:geolocator/geolocator.dart';

StreamSubscription<Position>? positionStream;

class LocationData {
  void startLocationUpdates() {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      // handle position updates
      print(
        'Latitude: ${position.latitude}, Longditude: ${position.longitude}',
      );
    });
  }

  void stopLocationUpdates() {
    positionStream?.cancel();
  }
}
