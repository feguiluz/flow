import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/people/data/models/people_sort_option.dart';
import 'package:flow/features/people/data/providers/people_sort_option_provider.dart';

/// Bottom sheet that lets the user pick how the people list is ordered.
/// Selection is persisted via [PeopleSortOptionNotifier] and the sheet
/// dismisses itself after the choice.
class PeopleSortSheet extends ConsumerWidget {
  const PeopleSortSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const PeopleSortSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selected = ref.watch(peopleSortOptionNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Text(
                'Ordenar por',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (final option in PeopleSortOption.values)
              RadioListTile<PeopleSortOption>(
                title: Text(option.displayLabel),
                value: option,
                groupValue: selected,
                onChanged: (value) async {
                  if (value == null) return;
                  await ref
                      .read(peopleSortOptionNotifierProvider.notifier)
                      .setSortOption(value);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
