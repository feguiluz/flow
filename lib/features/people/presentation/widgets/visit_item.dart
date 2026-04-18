import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/models/visit.dart';
import '../../../../shared/widgets/app_banner.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../data/providers/visit_notifier.dart';
import 'register_visit_sheet.dart';

/// Card widget displaying a single visit with edit/delete actions
class VisitItem extends ConsumerWidget {
  const VisitItem({
    super.key,
    required this.visit,
    required this.personId,
  });

  final Visit visit;
  final int personId;

  Future<void> _showNotesDialog(BuildContext context) async {
    if (visit.notes == null || visit.notes!.isEmpty) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notes, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                DateFormatter.getRelativeDate(visit.date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            visit.notes!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: RegisterVisitSheet(
            personId: personId,
            visit: visit,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Eliminar revisita',
      message: '¿Estás seguro de que deseas eliminar esta revisita? '
          'Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      isDestructive: true,
    );

    if (confirmed == true) {
      try {
        await ref
            .read(visitNotifierProvider(personId).notifier)
            .deleteVisit(visit.id!);

        if (context.mounted) {
          AppBanner.showSuccess(context, 'Visita eliminada');
        }
      } catch (e) {
        if (context.mounted) {
          AppBanner.showError(context, 'Error al eliminar: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: visit.notes != null && visit.notes!.isNotEmpty
            ? () => _showNotesDialog(context)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Leading icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.event_note,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Text(
                      DateFormatter.getRelativeDate(visit.date),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Short date
                    Text(
                      DateFormatter.formatForDisplay(visit.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Notes indicator
              if (visit.notes != null && visit.notes!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Tiene notas',
                  child: Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
              ],

              const SizedBox(width: 8),
              // Actions menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showEditSheet(context);
                      break;
                    case 'delete':
                      _confirmDelete(context, ref);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        const Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: colorScheme.error),
                        const SizedBox(width: 12),
                        const Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
