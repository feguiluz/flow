import 'package:flutter/material.dart';

/// Scope choice when mutating one instance of a recurring series.
enum SeriesScope {
  /// Apply the change only to the tapped occurrence.
  thisInstance,

  /// Apply the change to this occurrence and every future one.
  fromHere,
}

/// Asks the user whether an edit/delete on a recurring event should affect
/// only the tapped instance or every future occurrence in the series.
///
/// Returns `null` if the user cancels.
Future<SeriesScope?> showSeriesScopeDialog(
  BuildContext context, {
  required String title,
  String confirmTextThis = 'Solo este día',
  String confirmTextSeries = 'Toda la serie a partir de aquí',
  bool isDestructive = false,
}) {
  return showDialog<SeriesScope>(
    context: context,
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      final destructiveStyle = isDestructive
          ? FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            )
          : null;
      return AlertDialog(
        title: Text(title),
        content: const Text(
          'Esta visita se repite. ¿A qué ocurrencias quieres aplicar el cambio?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () =>
                Navigator.of(ctx).pop(SeriesScope.thisInstance),
            child: Text(confirmTextThis),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(SeriesScope.fromHere),
            style: destructiveStyle,
            child: Text(confirmTextSeries),
          ),
        ],
      );
    },
  );
}
