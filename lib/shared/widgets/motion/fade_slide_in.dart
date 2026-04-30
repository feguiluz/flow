import 'package:flutter/material.dart';

import 'package:flow/core/theme/motion.dart';

/// Animates [child] into view with a small upward slide and fade. Plays
/// once, on mount; afterwards the child is rendered untransformed.
///
/// Useful for individual list items, cards or sections that should appear
/// gracefully instead of popping in. Pair with [StaggeredEntries] when you
/// have several items that should enter sequentially.
///
/// Honours [motionAware]: when "Reduce motion" is on, the child appears
/// instantly with no animation.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration,
    this.beginOffset = const Offset(0, 0.08),
    this.curve = AppMotion.decelerate,
  });

  final Widget child;

  /// Delay before the animation starts. Useful for staggers.
  final Duration delay;

  /// Animation length. Defaults to [AppMotion.md].
  final Duration? duration;

  /// Start offset as a fraction of the child's size. Default is a small
  /// upward translation (~8 % of the height).
  final Offset beginOffset;

  final Curve curve;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AppMotion.md,
    );
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    _fade = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(curved);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _start();
  }

  Future<void> _start() async {
    final effectiveDuration = motionAware(
      context,
      widget.duration ?? AppMotion.md,
    );
    if (effectiveDuration == Duration.zero) {
      _controller.value = 1;
      return;
    }
    _controller.duration = effectiveDuration;
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
      if (!mounted) return;
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
