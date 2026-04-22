/// Backup file envelope for Flow app data.
///
/// Plain Dart classes (not freezed) because the payload is largely
/// "raw column rows" — Maps of column-name to SQLite values. Running those
/// through freezed+json_serializable adds friction with no type-safety win.
library;

class FlowBackup {
  const FlowBackup({
    required this.meta,
    required this.preferences,
    required this.data,
  });

  final BackupMeta meta;
  final Map<String, Object?> preferences;
  final BackupData data;

  Map<String, Object?> toJson() => {
        'meta': meta.toJson(),
        'preferences': preferences,
        'data': data.toJson(),
      };

  factory FlowBackup.fromJson(Map<String, Object?> json) {
    final meta = json['meta'];
    if (meta is! Map) {
      throw const FormatException('meta missing or malformed');
    }
    final prefs = json['preferences'];
    final data = json['data'];
    return FlowBackup(
      meta: BackupMeta.fromJson(_asStringMap(meta)),
      preferences: prefs is Map ? _asStringMap(prefs) : const {},
      data: data is Map
          ? BackupData.fromJson(_asStringMap(data))
          : const BackupData(),
    );
  }
}

class BackupMeta {
  const BackupMeta({
    required this.format,
    required this.appVersion,
    required this.schemaVersion,
    required this.createdAt,
  });

  /// Fixed identifier for the backup file format.
  static const String kFormat = 'flow-backup-v1';

  final String format;
  final String appVersion;
  final int schemaVersion;
  final String createdAt;

  Map<String, Object?> toJson() => {
        'format': format,
        'appVersion': appVersion,
        'schemaVersion': schemaVersion,
        'createdAt': createdAt,
      };

  factory BackupMeta.fromJson(Map<String, Object?> json) {
    final format = json['format'];
    final appVersion = json['appVersion'];
    final schemaVersion = json['schemaVersion'];
    final createdAt = json['createdAt'];
    if (format is! String) {
      throw const FormatException('meta.format missing');
    }
    if (schemaVersion is! int) {
      throw const FormatException('meta.schemaVersion missing or invalid');
    }
    return BackupMeta(
      format: format,
      appVersion: appVersion is String ? appVersion : '',
      schemaVersion: schemaVersion,
      createdAt: createdAt is String ? createdAt : '',
    );
  }
}

class BackupData {
  const BackupData({
    this.activities = const [],
    this.people = const [],
    this.visits = const [],
    this.goals = const [],
    this.participations = const [],
  });

  final List<Map<String, Object?>> activities;
  final List<Map<String, Object?>> people;
  final List<Map<String, Object?>> visits;
  final List<Map<String, Object?>> goals;
  final List<Map<String, Object?>> participations;

  Map<String, Object?> toJson() => {
        'activities': activities,
        'people': people,
        'visits': visits,
        'goals': goals,
        'participations': participations,
      };

  factory BackupData.fromJson(Map<String, Object?> json) {
    return BackupData(
      activities: _asRowList(json['activities']),
      people: _asRowList(json['people']),
      visits: _asRowList(json['visits']),
      goals: _asRowList(json['goals']),
      participations: _asRowList(json['participations']),
    );
  }
}

Map<String, Object?> _asStringMap(Map<dynamic, dynamic> m) {
  return m.map((k, v) => MapEntry(k.toString(), v));
}

List<Map<String, Object?>> _asRowList(Object? raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((m) => _asStringMap(m))
      .toList(growable: false);
}
