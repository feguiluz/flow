import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flow/features/backup/data/codecs/flow_file_codec.dart';
import 'package:flow/features/backup/data/providers/backup_provider.dart';
import 'package:flow/features/backup/data/services/backup_service.dart';
import 'package:flow/shared/widgets/app_banner.dart';
import 'package:flow/shared/widgets/confirmation_dialog.dart';

/// First screen shown on a fresh install. Offers two entry points:
///  - "Empezar" → advance to the regular onboarding wizard
///  - "Importar copia de seguridad" → restore from a .flow file and skip
///    onboarding entirely, landing directly on /home.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.auto_graph,
                size: 96,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Bienvenido a Flow',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Registra tu actividad de predicación de forma sencilla, '
                'rápida y privada.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => context.go('/onboarding'),
                  child: const Text(
                    'Empezar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if (!kIsWeb) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _handleImport(context, ref),
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text(
                      'Importar copia de seguridad',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Importar copia de seguridad',
      message: 'Se importarán tus datos y omitirás la configuración inicial. '
          '¿Continuar?',
      confirmText: 'Importar',
    );
    if (!confirmed || !context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(backupNotifierProvider.notifier).importForOnboarding();
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await _showImportSuccessDialog(context);
      if (!context.mounted) return;
      context.go('/home');
    } on BackupPickCancelled {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    } on BackupIncompleteProfileException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      AppBanner.showError(context, e.message);
    } on BackupVersionException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      AppBanner.showError(context, e.toString());
    } on BackupFormatException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      AppBanner.showError(context, e.message);
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      AppBanner.showError(context, 'Error al importar: $e');
    }
  }

  Future<void> _showImportSuccessDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: colorScheme.primary,
          size: 48,
        ),
        title: const Text('¡Listo!'),
        content: const Text(
          'Copia de seguridad importada con éxito.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
