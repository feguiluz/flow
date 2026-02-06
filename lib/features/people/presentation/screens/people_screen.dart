import 'package:flutter/material.dart';

/// People screen - Interested persons and Bible studies management
///
/// Displays:
/// - List of Bible studies with badge count
/// - List of interested persons/return visits
/// - Search functionality
/// - Add new person FAB
class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personas'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 64),
            SizedBox(height: 16),
            Text(
              'People Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text('Interested persons and Bible studies'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new person
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
