import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  static Future<void> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        debugPrint(
            'checkLocationPermission | status: Location permission granted');
      } else {
        // Handle case when user denies location permission
        debugPrint(
            'checkLocationPermission | status: Location permission denied');
        LocationPermission permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          debugPrint('requestPermission | status: Location permission granted');
        } else if (permission == LocationPermission.denied) {
          debugPrint('requestPermission | status: Location permission denied');
        } else {
          debugPrint(
              'requestPermission | status: Location permission denied forever');
        }
      }
    } catch (e) {
      debugPrint(
          "requestLocationPermission | status: Error requesting location permission: $e");
    }
  }

  static Future<Location> getUserLocation() async {
    try {
      // Retrieve User location data
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final Location location =
          Location(latitude: position.latitude, longitude: position.longitude);
      return location;
    } catch (e) {
      rethrow;
    }
  }
}
