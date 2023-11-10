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

  static Future<void> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Location permission granted, you can now proceed with location-related tasks
        debugPrint(
            'requestLocationPermission | status: Location permission granted');
      } else {
        // Handle case when user denies location permission
        debugPrint(
            'requestLocationPermission | status: Location permission denied');
      }
    } catch (e) {
      debugPrint(
          "requestLocationPermission | status: Error requesting location permission: $e");
    }
  }

  static Future<Location> getUserLocation() async {
    try {
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
