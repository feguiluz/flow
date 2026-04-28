import 'package:url_launcher/url_launcher.dart';

import 'package:flow/shared/models/person.dart';

/// Outcome of trying to open Google Maps for a person address.
enum MapsLaunchResult {
  launched,
  noAddress,
  failed,
}

/// Builds and launches Google Maps directions URLs for a [Person].
///
/// Prefers the person's `latitude`/`longitude` when both are present (most
/// accurate); falls back to the free-text `address`. Origin is left implicit
/// so Google Maps uses the device's current location.
class MapsLauncher {
  const MapsLauncher();

  /// Build a `https://www.google.com/maps/dir/?api=1` directions URL.
  ///
  /// Returns `null` when [person] has neither coordinates nor a non-empty
  /// address — the UI should hide the entry point in that case.
  Uri? buildDirectionsUri(Person person) {
    final params = <String, String>{
      'api': '1',
      'travelmode': 'driving',
    };
    final lat = person.latitude;
    final lng = person.longitude;
    if (lat != null && lng != null) {
      params['destination'] = '$lat,$lng';
    } else {
      final address = person.address?.trim();
      if (address == null || address.isEmpty) return null;
      params['destination'] = address;
    }
    return Uri.https('www.google.com', '/maps/dir/', params);
  }

  Future<MapsLaunchResult> openDirectionsTo(Person person) async {
    final uri = buildDirectionsUri(person);
    if (uri == null) return MapsLaunchResult.noAddress;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    return ok ? MapsLaunchResult.launched : MapsLaunchResult.failed;
  }
}
