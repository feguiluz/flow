import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/activity_list.dart';
import '../widgets/month_summary_card.dart';
import '../widgets/register_activity_sheet.dart';

/// Home screen - Monthly summary and activity registration
///
/// Displays:
/// - Month navigation with arrows
/// - Monthly summary card with goal progress
/// - Expandable service year summary
/// - Recent activity entries
/// - FAB to register new hours
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _showRegisterSheet() {
    final now = DateTime.now();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RegisterActivitySheet(
          initialDate: now,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Month Summary Card with goal progress
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: MonthSummaryCard(),
          ),

          // Divider
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Activity list section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Actividades del mes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Activity list with animation
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: ActivityList(
                key: ValueKey('${now.year}-${now.month}'),
                year: now.year,
                month: now.month,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRegisterSheet,
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
        tooltip: 'Registrar horas',
      ),
    );
  }
}
