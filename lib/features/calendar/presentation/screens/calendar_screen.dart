import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flow/core/utils/date_formatter.dart';
import 'package:flow/features/calendar/data/models/calendar_event.dart';
import 'package:flow/features/calendar/data/providers/event_provider.dart';
import 'package:flow/features/calendar/presentation/widgets/calendar_day_summary.dart';
import 'package:flow/features/calendar/presentation/widgets/event_detail_sheet.dart';
import 'package:flow/features/calendar/presentation/widgets/event_edit_sheet.dart';
import 'package:flow/features/calendar/presentation/widgets/event_list_item.dart';
import 'package:flow/features/home/data/providers/activity_notifier.dart';

/// Monthly calendar with event markers and an editable list of events for
/// the selected day. Predication activity is signalled with a secondary marker
/// per day and a summary card on the day list.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final monthEventsAsync =
        ref.watch(eventsByMonthProvider(_focusedDay.year, _focusedDay.month));
    final dayEventsAsync = ref.watch(eventsByDayProvider(_selectedDay));
    final monthMinutesAsync = ref.watch(
      minutesByDayForMonthProvider(_focusedDay.year, _focusedDay.month),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        actions: [
          IconButton(
            tooltip: 'Hoy',
            onPressed: () {
              final now = DateTime.now();
              setState(() {
                _focusedDay = DateTime(now.year, now.month, now.day);
                _selectedDay = _focusedDay;
              });
            },
            icon: const Icon(Icons.today),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TableCalendar<CalendarEvent>(
                locale: 'es_ES',
                firstDay: DateTime.utc(DateTime.now().year - 5, 1, 1),
                lastDay: DateTime.utc(DateTime.now().year + 5, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => _isSameDay(day, _selectedDay),
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Mes',
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: colorScheme.primary,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: colorScheme.primary,
                  ),
                  titleTextStyle: theme.textTheme.titleMedium ??
                      const TextStyle(fontSize: 16),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle:
                      TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                eventLoader: (day) {
                  // Use the monthly cache so we don't issue a query per day.
                  final events = monthEventsAsync.maybeWhen(
                    data: (list) => list
                        .where((e) => _isSameDay(e.date, day))
                        .toList(),
                    orElse: () => const <CalendarEvent>[],
                  );
                  return events;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final hasMinutes = monthMinutesAsync.maybeWhen(
                      data: (map) => (map[day.day] ?? 0) > 0,
                      orElse: () => false,
                    );
                    final hasEvents = events.isNotEmpty;
                    if (!hasEvents && !hasMinutes) return null;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasEvents)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (hasEvents && hasMinutes)
                            const SizedBox(width: 3),
                          if (hasMinutes)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                // Match the predication summary card colour.
                                color: Color(0xFF2E7D32), // Material green 800
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = _dateOnly(selected);
                    _focusedDay = focused;
                  });
                },
                onPageChanged: (focused) {
                  setState(() {
                    _focusedDay = focused;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormatter.formatWithDayOfWeek(_selectedDay)
                        .replaceFirstMapped(
                      RegExp(r'^.'),
                      (m) => m.group(0)!.toUpperCase(),
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
              children: [
                monthMinutesAsync.maybeWhen(
                  data: (map) {
                    final minutes = map[_selectedDay.day] ?? 0;
                    if (minutes <= 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CalendarDaySummary(minutes: minutes),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                dayEventsAsync.when(
                  data: (events) {
                    if (events.isEmpty) {
                      return const _EmptyDay();
                    }
                    return Column(
                      children: [
                        for (final event in events)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: EventListItem(
                              event: event,
                              onTap: () => _openDetail(context, event),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child:
                        Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $e'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateSheet(context),
        tooltip: 'Programar visita',
        child: const Icon(Icons.event),
      ),
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EventEditSheet(
        mode: EventEditMode.create,
        initialDate: _selectedDay,
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, CalendarEvent event) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EventDetailSheet(event: event),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'Sin visitas programadas',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
