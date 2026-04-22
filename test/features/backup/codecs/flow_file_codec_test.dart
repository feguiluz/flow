import 'package:flutter_test/flutter_test.dart';

import 'package:flow/core/database/database.dart';
import 'package:flow/features/backup/data/codecs/flow_file_codec.dart';
import 'package:flow/features/backup/data/models/flow_backup.dart';

void main() {
  const codec = FlowFileCodec();

  FlowBackup sampleBackup({int schemaVersion = AppDatabase.kDatabaseVersion}) {
    return FlowBackup(
      meta: BackupMeta(
        format: BackupMeta.kFormat,
        appVersion: '1.0.0',
        schemaVersion: schemaVersion,
        createdAt: '2026-04-18T17:30:00.000Z',
      ),
      preferences: {
        'user_name': 'Juan',
        'user_publisher_type': 'regularPioneer',
      },
      data: const BackupData(
        activities: [
          {
            'id': 1,
            'date': '2026-04-10',
            'minutes': 60,
            'notes': null,
            'created_at': '2026-04-10T10:00:00.000',
          },
        ],
        people: [
          {
            'id': 1,
            'name': 'Ana',
            'phone': null,
            'address': null,
            'notes': null,
            'is_bible_study': 1,
            'latitude': null,
            'longitude': null,
            'created_at': '2026-04-01T10:00:00.000',
          },
        ],
      ),
    );
  }

  group('FlowFileCodec', () {
    test('roundtrip preserves meta, preferences and row data', () {
      final original = sampleBackup();

      final raw = codec.encode(original);
      final decoded = codec.decode(raw);

      expect(decoded.meta.format, original.meta.format);
      expect(decoded.meta.schemaVersion, original.meta.schemaVersion);
      expect(decoded.meta.createdAt, original.meta.createdAt);
      expect(decoded.preferences, original.preferences);
      expect(decoded.data.activities, original.data.activities);
      expect(decoded.data.people, original.data.people);
      expect(decoded.data.visits, isEmpty);
      expect(decoded.data.goals, isEmpty);
      expect(decoded.data.participations, isEmpty);
    });

    test('accepts older schema versions (additive compatibility)', () {
      // Only run if the app has moved past v1 (always true here: current v5)
      if (AppDatabase.kDatabaseVersion <= 1) return;
      final older = sampleBackup(
        schemaVersion: AppDatabase.kDatabaseVersion - 1,
      );
      final raw = codec.encode(older);
      expect(() => codec.decode(raw), returnsNormally);
    });

    test('rejects schema versions newer than current', () {
      final future = sampleBackup(
        schemaVersion: AppDatabase.kDatabaseVersion + 1,
      );
      final raw = codec.encode(future);

      expect(
        () => codec.decode(raw),
        throwsA(isA<BackupVersionException>()),
      );
    });

    test('rejects unknown format identifiers', () {
      const raw = '''
      {
        "meta": {
          "format": "something-else",
          "appVersion": "1.0.0",
          "schemaVersion": 5,
          "createdAt": "2026-04-18T17:30:00.000Z"
        },
        "preferences": {},
        "data": {}
      }
      ''';
      expect(
        () => codec.decode(raw),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('rejects payloads missing meta', () {
      const raw = '{"preferences": {}, "data": {}}';
      expect(
        () => codec.decode(raw),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('rejects non-JSON input', () {
      expect(
        () => codec.decode('not json at all'),
        throwsA(isA<BackupFormatException>()),
      );
    });
  });
}
