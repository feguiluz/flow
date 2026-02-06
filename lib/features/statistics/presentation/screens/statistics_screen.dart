import 'package:flutter/material.dart';

/// Statistics screen - Charts and analytics
///
/// Displays:
/// - Bar chart showing hours per month
/// - Annual totals and averages
/// - Goal achievement tracking
/// - Participation history
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64),
            SizedBox(height: 16),
            Text(
              'Statistics Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text('Charts and analytics'),
          ],
        ),
      ),
    );
  }
}
