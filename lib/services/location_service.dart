import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static DateTime? _lastFetchTime;
  static LocationInfo? _cachedLocationInfo;

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<LocationInfo> getLocationInfo() async {
    // Check if cached data exists and is recent (within 5 minutes)
    if (_cachedLocationInfo != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < Duration(minutes: 5)) {
      return _cachedLocationInfo!;
    }

    try {
      final response = await http.get(Uri.parse('https://ipapi.co/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newLocationInfo = LocationInfo(
          ip: data['ip'],
          country: data['country_name'],
          city: data['city'],
        );

        // Cache the location info
        _cachedLocationInfo = newLocationInfo;
        _lastFetchTime = DateTime.now();

        return newLocationInfo;
      } else {
        throw Exception('Failed to get location info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get location info: $e');
    }
  }
}

class LocationInfo {
  final String ip;
  final String country;
  final String city;

  LocationInfo({required this.ip, required this.country, required this.city});
}
