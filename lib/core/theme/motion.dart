import 'package:flutter/material.dart';

/// Material 3 motion tokens centralised for the whole app.
///
/// Use these instead of magic numbers so animations stay consistent and
/// can be tuned in a single place. Durations follow M3 short/medium/long
/// buckets; curves cover the four reference roles.
abstract class AppMotion {
  // Durations
  static const Duration xs = Duration(milliseconds: 80);
  static const Duration sm = Duration(milliseconds: 150);
  static const Duration md = Duration(milliseconds: 250);
  static const Duration lg = Duration(milliseconds: 400);

  // Curves
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOut;
  static const Curve accelerate = Curves.easeIn;
  static const Curve emphasized = Curves.fastOutSlowIn;
}

/// Returns [duration] when the user has not requested reduced motion;
/// otherwise returns [Duration.zero] so the animation is effectively skipped.
///
/// All custom motion widgets in the app go through this helper so a single
/// system-level accessibility setting governs the entire UI.
Duration motionAware(BuildContext context, Duration duration) {
  return MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
