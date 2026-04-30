import 'package:flutter/material.dart';

import 'package:flow/core/theme/motion.dart';
import 'package:flow/shared/widgets/motion/fade_slide_in.dart';

/// Wraps a fixed list of [children] so each one enters with an incremental
/// delay, producing a staggered reveal. Each child is rendered through a
/// [FadeSlideIn].
///
/// Use the static [wrap] helper when you need the wrapped widgets for an
/// existing layout (a Row, a List of Slivers, etc.). Use the widget itself
/// for the common Column case.
class StaggeredEntries extends StatelessWidget {
  const StaggeredEntries({
    super.key,
    required this.children,
    this.stagger = AppMotion.xs,
    this.duration,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final Duration stagger;
  final Duration? duration;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  /// Returns [children] each wrapped in a [FadeSlideIn] with an incremental
  /// delay, ready to be inserted into any layout.
  static List<Widget> wrap(
    List<Widget> children, {
    Duration stagger = AppMotion.xs,
    Duration? duration,
  }) {
    return [
      for (var i = 0; i < children.length; i++)
        FadeSlideIn(
          key: ValueKey('staggered-$i'),
          delay: stagger * i,
          duration: duration,
          child: children[i],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: wrap(children, stagger: stagger, duration: duration),
    );
  }
}
