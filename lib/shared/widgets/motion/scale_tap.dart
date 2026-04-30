import 'package:flutter/material.dart';

import 'package:flow/core/theme/motion.dart';

/// Adds a subtle scale-down animation while the user is pressing on
/// [child], providing tactile feedback. Uses [Listener] so the inner
/// widget keeps full control of its own gestures (taps, ripples, etc.) —
/// this widget only observes pointer events to drive the animation.
///
/// Wrap any tap target that should "give" a little when pressed
/// (FloatingActionButton, important Cards, etc.). Honours reduced motion:
/// with that setting on, the child is rendered untransformed.
class ScaleTap extends StatefulWidget {
  const ScaleTap({
    super.key,
    required this.child,
    this.scale = 0.96,
    this.duration,
  });

  final Widget child;

  /// Smallest scale value reached while pressed. Default 0.96 (subtle).
  final double scale;

  /// Animation length. Defaults to [AppMotion.xs].
  final Duration? duration;

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration ?? AppMotion.xs,
    lowerBound: 0,
    upperBound: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down() => _controller.forward();
  void _up() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return Listener(
      onPointerDown: (_) => _down(),
      onPointerUp: (_) => _up(),
      onPointerCancel: (_) => _up(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 - ((1 - widget.scale) * _controller.value);
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
