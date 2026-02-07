import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../data/providers/activity_notifier.dart';
import '../widgets/activity_list.dart';
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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Always start with current month
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _showRegisterSheet() {
    // If selected month is current month, use today; otherwise use first day of month
    final now = DateTime.now();
    final initialDate = _isCurrentMonth()
        ? now // Current month: use today
        : DateTime(_selectedMonth.year, _selectedMonth.month,
            1); // Past month: use first day

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
    final colorScheme = theme.colorScheme;

    // Watch providers for selected month
    final totalMinutesAsync = ref.watch(
      getTotalMinutesForMonthProvider(
        year: _selectedMonth.year,
        month: _selectedMonth.month,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Month navigation
          _buildMonthNavigator(theme, colorScheme),

          // Monthly summary card (with expandable service year)
          _buildSummaryCard(theme, colorScheme, totalMinutesAsync),

          // Activity list section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Actividades',
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

  Widget _buildMonthNavigator(ThemeData theme, ColorScheme colorScheme) {
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
                  DateFormatter.getMonthYear(
                    _selectedMonth.year,
                    _selectedMonth.month,
                  ),
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

  Widget _buildSummaryCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AsyncValue<int> totalMinutesAsync,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Monthly total (always visible)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total del mes',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: totalMinutesAsync.when(
                          data: (minutes) => Text(
                            TimeFormatter.formatMinutesToHoursMinutes(minutes),
                            key: ValueKey(minutes),
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          loading: () => SizedBox(
                            key: const ValueKey('loading'),
                            height: 36,
                            width: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colorScheme.primary,
                            ),
                          ),
                          error: (_, __) => Text(
                            '--',
                            key: const ValueKey('error'),
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expand/collapse button
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExpanded
                        ? 'Ocultar año de servicio'
                        : 'Ver año de servicio',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Service year section (expandable)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildServiceYearSection(theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceYearSection(ThemeData theme, ColorScheme colorScheme) {
    // Calculate service year for selected month
    final serviceYear = AppConstants.getServiceYearForDate(_selectedMonth);
    final startYear = serviceYear[0];

    // Get last day of selected month for "up to" calculation
    final lastDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );

    // Watch service year total provider
    final serviceYearTotalAsync = ref.watch(
      serviceYearTotalUpToProvider(
        startYear: startYear,
        upToDate: lastDayOfMonth,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.formatServiceYear(serviceYear),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          serviceYearTotalAsync.when(
            data: (minutes) => Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total acumulado hasta ${DateFormatter.getMonthName(_selectedMonth.month)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        TimeFormatter.formatMinutesToHoursMinutes(minutes),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(
              'Error al cargar',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
