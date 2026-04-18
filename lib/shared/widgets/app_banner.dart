import 'package:flutter/material.dart';

/// Helper class for showing app-wide overlay notifications
class AppBanner {
  AppBanner._();

  /// Show a success notification at the top of the screen
  static void showSuccess(BuildContext context, String message) {
    _showOverlay(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  /// Show an error notification at the top of the screen
  static void showError(BuildContext context, String message) {
    _showOverlay(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
    );
  }

  /// Show an info notification at the top of the screen
  static void showInfo(BuildContext context, String message) {
    _showOverlay(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
    );
  }

  /// Internal method to show an overlay notification
  static void _showOverlay(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    late _BannerWidgetState bannerState;

    overlayEntry = OverlayEntry(
      builder: (context) => _BannerWidget(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        onDismiss: () => overlayEntry.remove(),
        onStateCreated: (state) => bannerState = state,
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after 2 seconds with animation
    Future.delayed(const Duration(seconds: 2), () async {
      if (overlayEntry.mounted) {
        await bannerState.dismiss();
      }
    });
  }
}

/// Internal widget for displaying the banner notification
class _BannerWidget extends StatefulWidget {
  const _BannerWidget({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onDismiss,
    required this.onStateCreated,
  });

  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onDismiss;
  final void Function(_BannerWidgetState state) onStateCreated;

  @override
  State<_BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<_BannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    // Notify parent that state is created
    widget.onStateCreated(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Dismiss the banner with animation
  Future<void> dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          color: widget.backgroundColor,
          child: InkWell(
            onTap: dismiss,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: widget.foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.foregroundColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
