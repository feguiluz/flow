import 'package:flutter_test/flutter_test.dart';

import 'package:flow/core/utils/maps_launcher.dart';
import 'package:flow/shared/models/person.dart';

Person _person({
  String? address,
  double? latitude,
  double? longitude,
}) {
  return Person(
    name: 'María',
    address: address,
    latitude: latitude,
    longitude: longitude,
    isBibleStudy: false,
    createdAt: DateTime(2026, 4, 28),
  );
}

void main() {
  group('MapsLauncher.buildDirectionsUri', () {
    const sut = MapsLauncher();

    test('uses address text when only address is present', () {
      final uri = sut.buildDirectionsUri(
        _person(address: 'Calle Mayor 12, Madrid'),
      );

      expect(uri, isNotNull);
      expect(uri!.host, 'www.google.com');
      expect(uri.path, '/maps/dir/');
      expect(uri.queryParameters['destination'], 'Calle Mayor 12, Madrid');
      expect(uri.queryParameters['api'], '1');
      expect(uri.queryParameters['travelmode'], 'driving');
    });

    test('falls back to lat/lng when address is missing', () {
      final uri = sut.buildDirectionsUri(
        _person(latitude: 40.4168, longitude: -3.7038),
      );

      expect(uri, isNotNull);
      expect(uri!.queryParameters['destination'], '40.4168,-3.7038');
    });

    test('prefers address text over coordinates when both are present', () {
      // Coords can drift from the address text when the user auto-captured
      // the location and then manually edited the street/number. The text
      // is treated as the source of truth.
      final uri = sut.buildDirectionsUri(
        _person(
          address: 'Calle Mayor 12, Madrid',
          latitude: 40.4168,
          longitude: -3.7038,
        ),
      );

      expect(uri!.queryParameters['destination'], 'Calle Mayor 12, Madrid');
    });

    test('returns null when person has neither coords nor address', () {
      expect(sut.buildDirectionsUri(_person()), isNull);
    });

    test('returns null when address is empty or whitespace', () {
      expect(sut.buildDirectionsUri(_person(address: '')), isNull);
      expect(sut.buildDirectionsUri(_person(address: '   ')), isNull);
    });

    test('encodes special characters in address (accents, comma, ampersand)',
        () {
      final uri = sut.buildDirectionsUri(
        _person(address: 'Avenida de la Constitución, 12 & B, Sevilla'),
      );

      // queryParameters returns the decoded value; check the raw query is
      // properly percent-encoded.
      expect(uri, isNotNull);
      expect(
        uri!.queryParameters['destination'],
        'Avenida de la Constitución, 12 & B, Sevilla',
      );
      // The encoded form must contain percent escapes for non-ASCII and `&`.
      expect(uri.query, contains('%C3%B3')); // ó
      expect(uri.query, contains('%26')); // &
    });

    test('only one coordinate present (lat without lng) still uses address',
        () {
      final uri = sut.buildDirectionsUri(
        _person(latitude: 40.4, address: 'Calle Sol 3'),
      );

      expect(uri!.queryParameters['destination'], 'Calle Sol 3');
    });

    test('half coordinates without address returns null', () {
      // Defensive: coords are stored as a pair; lat-only is meaningless.
      expect(sut.buildDirectionsUri(_person(latitude: 40.4)), isNull);
      expect(sut.buildDirectionsUri(_person(longitude: -3.7)), isNull);
    });

    test('always emits travelmode=driving', () {
      final byCoords =
          sut.buildDirectionsUri(_person(latitude: 1, longitude: 2));
      final byAddress = sut.buildDirectionsUri(_person(address: 'Calle X'));

      expect(byCoords!.queryParameters['travelmode'], 'driving');
      expect(byAddress!.queryParameters['travelmode'], 'driving');
    });
  });
}
