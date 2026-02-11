import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flow/core/utils/date_formatter.dart';
import 'package:flow/features/home/data/providers/activity_notifier.dart';
import 'package:flow/features/home/data/providers/participation_notifier.dart';
import 'package:flow/features/people/data/providers/visit_notifier.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';

part 'export_provider.g.dart';

/// Generate text report for a specific month
@riverpod
Future<String> generateTextReport(
  GenerateTextReportRef ref,
  int year,
  int month,
) async {
  final userProfile = await ref.watch(userProfileProvider.future);
  final userName = userProfile.name ?? 'Publicador';

  // Get month name in Spanish
  final monthName = DateFormatter.getMonthName(month);

  // Build report header
  final buffer = StringBuffer();
  buffer.writeln('📊 INFORME DE PREDICACIÓN');
  buffer.writeln('$monthName $year');
  buffer.writeln('');
  buffer.writeln('Nombre: $userName');
  buffer.writeln('');

  // Different format based on publisher type
  if (userProfile.publisherType == PublisherType.publisher) {
    // Publisher without goal - only participation
    final participation = await ref.watch(
      participationNotifierProvider(year, month).future,
    );

    if (participation?.participated == true) {
      buffer.writeln('✅ Participé en el ministerio');
    } else {
      buffer.writeln('❌ No participé en el ministerio');
    }
  } else {
    // Pioneer (Regular or Special) - hours and bible studies

    // Get total hours
    final totalMinutes = await ref.watch(
      getTotalMinutesForMonthProvider(year: year, month: month).future,
    );
    final hours = totalMinutes / 60.0;

    // Get bible studies count
    final bibleStudiesCount = await ref.watch(
      bibleStudiesCountForMonthProvider(year, month).future,
    );

    buffer.writeln('⏱️ Horas: ${hours.toStringAsFixed(1)}');
    buffer.writeln('📚 Cursos Bíblicos: $bibleStudiesCount');
  }

  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('Generado con Flow');

  return buffer.toString();
}

/// Share report via WhatsApp or other apps
Future<void> shareMonthReport(WidgetRef ref, int year, int month) async {
  try {
    final report = await ref.read(
      generateTextReportProvider(year, month).future,
    );
    
    await Share.share(
      report,
      subject: 'Informe de Predicación - ${DateFormatter.getMonthName(month)} $year',
    );
  } catch (e) {
    throw Exception('Error al compartir informe: $e');
  }
}

/// Generate PDF report (to be implemented)
/// This is a placeholder for future PDF export functionality
Future<void> generatePdfReport(WidgetRef ref, int year, int month) async {
  // TODO: Implement PDF generation using pdf package
  throw UnimplementedError('PDF export coming soon');
}
}
