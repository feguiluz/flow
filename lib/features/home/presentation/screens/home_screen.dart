import 'package:flutter/material.dart';

/// Home screen - Monthly summary and activity registration
///
/// Displays:
/// - Monthly summary card with goal progress
/// - Quick action to register hours
/// - Recent activity entries
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text(
              'Home Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text('Monthly summary and activity registration'),
          ],
        ),
      ),
    );
  }
}
