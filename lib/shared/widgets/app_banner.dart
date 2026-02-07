import 'package:flutter/material.dart';

/// Helper class for showing app-wide banners
class AppBanner {
  AppBanner._();

  /// Show a success banner at the top of the screen
  static void showSuccess(BuildContext context, String message) {
    _showBanner(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  /// Show an error banner at the top of the screen
  static void showError(BuildContext context, String message) {
    _showBanner(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
    );
  }

  /// Show an info banner at the top of the screen
  static void showInfo(BuildContext context, String message) {
    _showBanner(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
    );
  }

  /// Internal method to show a banner
  static void _showBanner(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    // Remove any existing banner first
    ScaffoldMessenger.of(context).clearMaterialBanners();

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Row(
          children: [
            Icon(icon, color: foregroundColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              'OK',
              style: TextStyle(color: foregroundColor),
            ),
          ),
        ],
      ),
    );

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
