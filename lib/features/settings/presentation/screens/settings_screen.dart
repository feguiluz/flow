import 'package:flutter/material.dart';

/// Settings screen - Profile and configuration
///
/// Displays:
/// - User profile (name, default goal type)
/// - Special pioneer age/gender settings
/// - Export options (PDF, WhatsApp)
/// - Theme selection (light/dark/system)
/// - About & version info
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64),
            SizedBox(height: 16),
            Text(
              'Settings Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text('Profile and configuration'),
          ],
        ),
      ),
    );
  }
}
