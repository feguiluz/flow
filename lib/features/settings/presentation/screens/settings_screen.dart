import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/settings/data/providers/export_provider.dart';
import 'package:flow/shared/widgets/app_banner.dart';

/// Settings screen - Profile and configuration
///
/// Displays:
/// - User profile (name, default goal type)
/// - Special pioneer age/gender settings
/// - Export options (PDF, WhatsApp)
/// - Theme selection (light/dark/system)
/// - About & version info
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          //  Export Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'EXPORTAR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.share,
                color: colorScheme.primary,
              ),
              title: const Text('Compartir informe del mes'),
              subtitle: const Text('Enviar por WhatsApp u otras apps'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                try {
                  final now = DateTime.now();
                  await shareMonthReport(ref, now.year, now.month);
                  if (context.mounted) {
                    AppBanner.showSuccess(
                      context,
                      'Informe compartido correctamente',
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    AppBanner.showError(
                      context,
                      'Error al compartir: $e',
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
