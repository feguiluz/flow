import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/utils/date_formatter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    // Initialize Spanish locale for tests
    await initializeDateFormatting('es_ES', null);
    Intl.defaultLocale = 'es_ES';
  });

  group('DateFormatter', () {
    group('formatForDisplay', () {
      test('formats date in dd/MM/yyyy format', () {
        final date = DateTime(2026, 2, 7);
        final result = DateFormatter.formatForDisplay(date);

        expect(result, equals('07/02/2026'));
      });

      test('pads single digits with zeros', () {
        final date = DateTime(2026, 1, 5);
        final result = DateFormatter.formatForDisplay(date);

        expect(result, equals('05/01/2026'));
      });

      test('handles different years', () {
        final date = DateTime(2020, 12, 31);
        final result = DateFormatter.formatForDisplay(date);

        expect(result, equals('31/12/2020'));
      });
    });

    group('formatForDb', () {
      test('formats date in yyyy-MM-dd format', () {
        final date = DateTime(2026, 2, 7);
        final result = DateFormatter.formatForDb(date);

        expect(result, equals('2026-02-07'));
      });

      test('pads single digits with zeros', () {
        final date = DateTime(2026, 1, 5);
        final result = DateFormatter.formatForDb(date);

        expect(result, equals('2026-01-05'));
      });

      test('is suitable for SQL ordering', () {
        final dates = [
          DateTime(2026, 1, 15),
          DateTime(2026, 2, 1),
          DateTime(2025, 12, 31),
        ];

        final formatted = dates.map(DateFormatter.formatForDb).toList();
        formatted.sort();

        expect(
            formatted,
            equals([
              '2025-12-31',
              '2026-01-15',
              '2026-02-01',
            ]));
      });
    });

    group('parseFromDb', () {
      test('parses yyyy-MM-dd format correctly', () {
        final result = DateFormatter.parseFromDb('2026-02-07');

        expect(result.year, equals(2026));
        expect(result.month, equals(2));
        expect(result.day, equals(7));
      });

      test('parses dates with single digit components', () {
        final result = DateFormatter.parseFromDb('2026-01-05');

        expect(result.year, equals(2026));
        expect(result.month, equals(1));
        expect(result.day, equals(5));
      });

      test('round-trips with formatForDb', () {
        final original = DateTime(2026, 2, 7);
        final formatted = DateFormatter.formatForDb(original);
        final parsed = DateFormatter.parseFromDb(formatted);

        expect(parsed.year, equals(original.year));
        expect(parsed.month, equals(original.month));
        expect(parsed.day, equals(original.day));
      });
    });

    group('getMonthName', () {
      test('returns correct Spanish month names', () {
        expect(DateFormatter.getMonthName(1), equals('Enero'));
        expect(DateFormatter.getMonthName(2), equals('Febrero'));
        expect(DateFormatter.getMonthName(3), equals('Marzo'));
        expect(DateFormatter.getMonthName(4), equals('Abril'));
        expect(DateFormatter.getMonthName(5), equals('Mayo'));
        expect(DateFormatter.getMonthName(6), equals('Junio'));
        expect(DateFormatter.getMonthName(7), equals('Julio'));
        expect(DateFormatter.getMonthName(8), equals('Agosto'));
        expect(DateFormatter.getMonthName(9), equals('Septiembre'));
        expect(DateFormatter.getMonthName(10), equals('Octubre'));
        expect(DateFormatter.getMonthName(11), equals('Noviembre'));
        expect(DateFormatter.getMonthName(12), equals('Diciembre'));
      });

      test('throws for invalid month numbers', () {
        expect(() => DateFormatter.getMonthName(0), throwsArgumentError);
        expect(() => DateFormatter.getMonthName(13), throwsArgumentError);
        expect(() => DateFormatter.getMonthName(-1), throwsArgumentError);
      });
    });

    group('getMonthAbbr', () {
      test('returns correct Spanish month abbreviations', () {
        expect(DateFormatter.getMonthAbbr(1), equals('Ene'));
        expect(DateFormatter.getMonthAbbr(2), equals('Feb'));
        expect(DateFormatter.getMonthAbbr(3), equals('Mar'));
        expect(DateFormatter.getMonthAbbr(4), equals('Abr'));
        expect(DateFormatter.getMonthAbbr(5), equals('May'));
        expect(DateFormatter.getMonthAbbr(6), equals('Jun'));
        expect(DateFormatter.getMonthAbbr(7), equals('Jul'));
        expect(DateFormatter.getMonthAbbr(8), equals('Ago'));
        expect(DateFormatter.getMonthAbbr(9), equals('Sep'));
        expect(DateFormatter.getMonthAbbr(10), equals('Oct'));
        expect(DateFormatter.getMonthAbbr(11), equals('Nov'));
        expect(DateFormatter.getMonthAbbr(12), equals('Dic'));
      });

      test('throws for invalid month numbers', () {
        expect(() => DateFormatter.getMonthAbbr(0), throwsArgumentError);
        expect(() => DateFormatter.getMonthAbbr(13), throwsArgumentError);
      });
    });

    group('getMonthYear', () {
      test('returns formatted month and year in Spanish', () {
        expect(DateFormatter.getMonthYear(2026, 2), equals('Febrero 2026'));
        expect(DateFormatter.getMonthYear(2025, 9), equals('Septiembre 2025'));
        expect(DateFormatter.getMonthYear(2020, 1), equals('Enero 2020'));
      });
    });

    group('getRelativeDate', () {
      test('returns "Hoy" for today', () {
        final today = DateTime.now();
        final result = DateFormatter.getRelativeDate(today);

        expect(result, equals('Hoy'));
      });

      test('returns "Ayer" for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final result = DateFormatter.getRelativeDate(yesterday);

        expect(result, equals('Ayer'));
      });

      test('returns formatted date for other dates', () {
        final date = DateTime(2026, 1, 15);
        final result = DateFormatter.getRelativeDate(date);

        // Should return format like "Jue, 15 de enero"
        expect(result, contains('15'));
        expect(result, contains('enero'));
      });

      test('ignores time component when checking today', () {
        final now = DateTime.now();
        final todayMorning = DateTime(now.year, now.month, now.day, 8, 0);
        final todayEvening = DateTime(now.year, now.month, now.day, 20, 0);

        expect(DateFormatter.getRelativeDate(todayMorning), equals('Hoy'));
        expect(DateFormatter.getRelativeDate(todayEvening), equals('Hoy'));
      });
    });

    group('formatWithDayOfWeek', () {
      test('includes day of week in Spanish', () {
        final date = DateTime(2026, 2, 9); // Monday
        final result = DateFormatter.formatWithDayOfWeek(date);

        expect(result, contains('lunes'));
        expect(result, contains('9'));
        expect(result, contains('febrero'));
        expect(result, contains('2026'));
      });

      test('formats complete date with day name', () {
        final date = DateTime(2026, 1, 1); // Thursday
        final result = DateFormatter.formatWithDayOfWeek(date);

        expect(result, contains('jueves'));
      });
    });
  });
}
