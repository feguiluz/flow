import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Service for handling location and geocoding operations
class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      // On web, this may throw, so we assume it's enabled if we can access it
      if (kIsWeb) {
        return true; // Browser will handle permissions
      }
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Check and request location permission
  Future<LocationPermission> checkPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission;
    } catch (e) {
      // On web or other platforms, assume permission will be requested by the browser
      return LocationPermission.denied;
    }
  }

  /// Get current position
  ///
  /// Returns null if permission is denied or location service is disabled
  Future<Position?> getCurrentPosition() async {
    try {
      if (kIsWeb) {
        // On web, directly try to get position
        // The browser will handle permission prompts
        try {
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 15),
          );
        } catch (e) {
          // If error, try with lower accuracy
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 15),
          );
        }
      }

      // Native platforms (Android/iOS)
      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      final permission = await checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get position with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // Handle all errors (including permission denied, timeout, etc.)
      // Log error for debugging
      print('LocationService error: $e');
      return null;
    }
  }

  /// Get address from coordinates (reverse geocoding)
  ///
  /// Returns formatted address string or null if geocoding fails
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      if (kIsWeb) {
        // On web, use Nominatim API (OpenStreetMap) for reverse geocoding
        return await _reverseGeocodeWeb(latitude, longitude);
      }

      // Native platforms (Android/iOS) - use geocoding package
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return null;
      }

      final place = placemarks.first;

      // Build address string from available components
      final parts = <String>[];

      // Street address with house number
      // Note: On native, street often includes the number already
      // e.g., "123 Main Street" or "Calle Mayor, 10"
      if (place.street != null && place.street!.isNotEmpty) {
        final street = place.street!;
        final subThoroughfare = place.subThoroughfare; // House number

        // If street doesn't contain number and we have subThoroughfare
        if (subThoroughfare != null &&
            subThoroughfare.isNotEmpty &&
            !street.contains(subThoroughfare)) {
          // Format: "Street Name, Number"
          parts.add('$street, $subThoroughfare');
        } else {
          // Street already contains number or no number available
          parts.add(street);
        }
      } else if (place.subThoroughfare != null &&
          place.subThoroughfare!.isNotEmpty) {
        // Only house number (rare)
        parts.add(place.subThoroughfare!);
      }

      // Locality (city/town)
      if (place.locality != null && place.locality!.isNotEmpty) {
        parts.add(place.locality!);
      }

      // Postal code
      if (place.postalCode != null && place.postalCode!.isNotEmpty) {
        parts.add(place.postalCode!);
      }

      // Country
      if (place.country != null && place.country!.isNotEmpty) {
        parts.add(place.country!);
      }

      return parts.isEmpty ? null : parts.join(', ');
    } catch (e) {
      // If geocoding fails, return coordinates as fallback
      return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
    }
  }

  /// Reverse geocoding for web using Nominatim API
  Future<String?> _reverseGeocodeWeb(
    double latitude,
    double longitude,
  ) async {
    try {
      // Use Nominatim API (OpenStreetMap) - free and no API key required
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?'
        'format=json&'
        'lat=$latitude&'
        'lon=$longitude&'
        'addressdetails=1&'
        'accept-language=es',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FlowApp/1.0', // Required by Nominatim
        },
      );

      if (response.statusCode != 200) {
        print('Nominatim API error: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      // Debug: print full response
      print('🗺️ Nominatim response: ${json.encode(data)}');

      final address = data['address'] as Map<String, dynamic>?;
      if (address == null) {
        print('⚠️ No address data received');
        return null;
      }

      // Debug: print address components
      print('📍 Address components: ${json.encode(address)}');

      final parts = <String>[];

      // Try multiple fields for street name (Nominatim uses different keys)
      var street = address['road'] as String? ??
          address['street'] as String? ??
          address['pedestrian'] as String? ??
          address['footway'] as String? ??
          address['path'] as String?;

      // Try multiple fields for house number
      final houseNumber = address['house_number'] as String? ??
          address['housenumber'] as String?;

      if (street != null && street.isNotEmpty) {
        // Add house number if available
        if (houseNumber != null && houseNumber.isNotEmpty) {
          parts.add('$street, $houseNumber');
          print('✅ Street with number: $street, $houseNumber');
        } else {
          // Only street name (user can add number manually later)
          parts.add(street);
          print('ℹ️ Street without number: $street (user can add manually)');
        }
      } else if (houseNumber != null && houseNumber.isNotEmpty) {
        // Only house number (rare case)
        parts.add(houseNumber);
        print('⚠️ Only house number: $houseNumber');
      } else {
        print('⚠️ No street or house number found');
      }

      // Colonia/Neighborhood (México: residential, suburb, neighbourhood)
      final colonia = address['residential'] as String? ??
          address['suburb'] as String? ??
          address['neighbourhood'] as String?;
      if (colonia != null) {
        parts.add(colonia);
      }

      // Municipality/City
      final municipality = address['city'] as String? ??
          address['town'] as String? ??
          address['municipality'] as String? ??
          address['county'] as String?;
      if (municipality != null) {
        parts.add(municipality);
      }

      // Postal code
      final postcode = address['postcode'] as String?;
      if (postcode != null) {
        parts.add(postcode);
      }

      final result = parts.isEmpty ? null : parts.join(', ');
      print(
          '🏠 Final address (Calle, Número, Colonia, Municipio, CP): $result');

      return result;
    } catch (e) {
      print('❌ Web geocoding error: $e');
      return null;
    }
  }

  /// Get current location and convert to address
  ///
  /// Returns a record with (address, latitude, longitude) or null if failed
  Future<({String address, double latitude, double longitude})?>
      getCurrentLocationWithAddress() async {
    // Get position
    final position = await getCurrentPosition();
    if (position == null) {
      return null;
    }

    // Get address from coordinates
    final address = await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (address == null) {
      return null;
    }

    return (
      address: address,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
