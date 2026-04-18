import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/utils/constants.dart';

void main() {
  group('AppConstants - Service Year', () {
    test('serviceYearStartMonth should be September (9)', () {
      expect(AppConstants.serviceYearStartMonth, equals(9));
    });

    group('getServiceYearForDate', () {
      test('returns correct service year for September (start of year)', () {
        final date = DateTime(2025, 9, 1); // Sep 1, 2025
        final result = AppConstants.getServiceYearForDate(date);

        expect(result, equals([2025, 2026]));
      });

      test('returns correct service year for August (end of year)', () {
        final date = DateTime(2026, 8, 31); // Aug 31, 2026
        final result = AppConstants.getServiceYearForDate(date);

        expect(result, equals([2025, 2026]));
      });

      test('returns correct service year for January (mid year)', () {
        final date = DateTime(2026, 1, 15); // Jan 15, 2026
        final result = AppConstants.getServiceYearForDate(date);

        expect(result, equals([2025, 2026]));
      });

      test('returns correct service year for October', () {
        final date = DateTime(2025, 10, 1); // Oct 1, 2025
        final result = AppConstants.getServiceYearForDate(date);

        expect(result, equals([2025, 2026]));
      });

      test('handles year transition correctly (Sep to Aug)', () {
        // Last day of previous service year
        final endDate = DateTime(2025, 8, 31);
        expect(
          AppConstants.getServiceYearForDate(endDate),
          equals([2024, 2025]),
        );

        // First day of new service year
        final startDate = DateTime(2025, 9, 1);
        expect(
          AppConstants.getServiceYearForDate(startDate),
          equals([2025, 2026]),
        );
      });

      test('works for different years', () {
        expect(
          AppConstants.getServiceYearForDate(DateTime(2020, 12, 1)),
          equals([2020, 2021]),
        );

        expect(
          AppConstants.getServiceYearForDate(DateTime(2030, 5, 15)),
          equals([2029, 2030]),
        );
      });
    });

    group('formatServiceYear', () {
      test('formats service year correctly in Spanish', () {
        final result = AppConstants.formatServiceYear([2025, 2026]);
        expect(result, equals('Año de servicio 2025-2026'));
      });

      test('handles different years', () {
        expect(
          AppConstants.formatServiceYear([2020, 2021]),
          equals('Año de servicio 2020-2021'),
        );
      });
    });

    group('getServiceYearStartDate', () {
      test('returns September 1st of start year', () {
        final result = AppConstants.getServiceYearStartDate(2025);

        expect(result.year, equals(2025));
        expect(result.month, equals(9));
        expect(result.day, equals(1));
      });

      test('works for different years', () {
        final result2020 = AppConstants.getServiceYearStartDate(2020);
        expect(result2020, equals(DateTime(2020, 9, 1)));

        final result2030 = AppConstants.getServiceYearStartDate(2030);
        expect(result2030, equals(DateTime(2030, 9, 1)));
      });
    });

    group('getServiceYearEndDate', () {
      test('returns August 31st of following year', () {
        final result = AppConstants.getServiceYearEndDate(2025);

        expect(result.year, equals(2026));
        expect(result.month, equals(8));
        expect(result.day, equals(31));
      });

      test('works for different years', () {
        final result2020 = AppConstants.getServiceYearEndDate(2020);
        expect(result2020, equals(DateTime(2021, 8, 31)));

        final result2030 = AppConstants.getServiceYearEndDate(2030);
        expect(result2030, equals(DateTime(2031, 8, 31)));
      });
    });

    group('Full service year cycle', () {
      test('all months map to correct service year', () {
        // Service year 2025-2026
        for (int month = 9; month <= 12; month++) {
          final date = DateTime(2025, month, 15);
          expect(
            AppConstants.getServiceYearForDate(date),
            equals([2025, 2026]),
            reason: 'Failed for month $month/2025',
          );
        }

        for (int month = 1; month <= 8; month++) {
          final date = DateTime(2026, month, 15);
          expect(
            AppConstants.getServiceYearForDate(date),
            equals([2025, 2026]),
            reason: 'Failed for month $month/2026',
          );
        }
      });
    });
  });

  group('AppConstants - Other', () {
    test('maxHoursPerDay is 24', () {
      expect(AppConstants.maxHoursPerDay, equals(24));
    });

    test('date formats are correct', () {
      expect(AppConstants.dbDateFormat, equals('yyyy-MM-dd'));
      expect(AppConstants.displayDateFormat, equals('dd/MM/yyyy'));
    });
  });
}
