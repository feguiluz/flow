import 'package:flutter/material.dart';

import 'package:flow/core/theme/motion.dart';

/// PageRoute used by `Navigator.push` calls inside the app shell so that
/// pushed screens (person detail, profile edit, etc.) enter with a subtle
/// horizontal slide + fade in line with the motion system, instead of the
/// full Material slide-up.
///
/// Hero animations work transparently across this route — Flutter detects
/// matching `Hero` tags between source and destination regardless of the
/// page route subclass.
PageRoute<T> appRoute<T>({required WidgetBuilder builder}) {
  return PageRouteBuilder<T>(
    transitionDuration: AppMotion.md,
    reverseTransitionDuration: AppMotion.sm,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      if (reduceMotion) return child;
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.emphasized,
        reverseCurve: AppMotion.accelerate,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(curved);
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}
