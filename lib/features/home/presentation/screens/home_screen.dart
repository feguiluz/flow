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
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _showRegisterSheet() {
    // If selected month is current month, use today; otherwise use first day of month
    final now = DateTime.now();
    final initialDate = _isCurrentMonth()
        ? now
        : DateTime(_selectedMonth.year, _selectedMonth.month, 1);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RegisterActivitySheet(
          initialDate: initialDate,
        ),
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    // Only allow going forward if not in current month
    if (_selectedMonth.isBefore(currentMonth)) {
      setState(() {
        _selectedMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + 1,
        );
      });
    }
  }

  bool _isCurrentMonth() {
    final now = DateTime.now();
    return _selectedMonth.year == now.year && _selectedMonth.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Month navigation
          _buildMonthNavigator(theme),

          // Month Summary Card with goal progress
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MonthSummaryCard(
              year: _selectedMonth.year,
              month: _selectedMonth.month,
            ),
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
                key: ValueKey('${_selectedMonth.year}-${_selectedMonth.month}'),
                year: _selectedMonth.year,
                month: _selectedMonth.month,
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

  Widget _buildMonthNavigator(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous month button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _goToPreviousMonth,
            tooltip: 'Mes anterior',
          ),

          // Month display with badge
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getMonthYearText(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_isCurrentMonth()) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Mes actual',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Next month button (disabled if current month)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _isCurrentMonth() ? null : _goToNextMonth,
            tooltip: _isCurrentMonth() ? null : 'Mes siguiente',
          ),
        ],
      ),
    );
  }

  String _getMonthYearText() {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}';
  }
}
