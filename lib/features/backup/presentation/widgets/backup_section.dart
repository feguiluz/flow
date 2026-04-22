import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/backup/data/codecs/flow_file_codec.dart';
import 'package:flow/features/backup/data/providers/backup_provider.dart';
import 'package:flow/shared/widgets/app_banner.dart';
import 'package:flow/shared/widgets/confirmation_dialog.dart';

/// Settings section with "Exportar" and "Importar" tiles for the
/// local backup system.
class BackupSection extends ConsumerWidget {
  const BackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (kIsWeb) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.info_outline, color: colorScheme.primary),
          title: const Text('No disponible en web'),
          subtitle: const Text(
            'La copia de seguridad local solo está disponible en la app móvil.',
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.upload_file, color: colorScheme.primary),
            title: const Text('Exportar copia de seguridad'),
            subtitle: const Text(
              'Crea un archivo .flow con todos tus datos',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _handleExport(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.download_for_offline,
              color: colorScheme.primary,
            ),
            title: const Text('Importar copia de seguridad'),
            subtitle: const Text(
              'Reemplaza todos los datos actuales con los del archivo',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _handleImport(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject();
    final origin = box is RenderBox
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    try {
      await ref.read(backupNotifierProvider.notifier).exportAndShare(
            sharePositionOrigin: origin,
          );
    } catch (e) {
      if (!context.mounted) return;
      AppBanner.showError(context, 'No se pudo exportar: $e');
    }
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Importar copia de seguridad',
      message:
          'Se reemplazarán todos tus datos actuales (perfil, actividades, '
          'personas, visitas, metas y participaciones) con los del archivo. '
          'Esta acción no se puede deshacer fácilmente.',
      confirmText: 'Importar',
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;

    // Progress dialog while the import runs.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(backupNotifierProvider.notifier).importFromPicker();
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close progress
      AppBanner.showSuccess(context, 'Copia de seguridad importada con éxito');
    } on BackupPickCancelled {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close progress
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
}
