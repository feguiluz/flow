/// Types of publishers in the ministry
enum PublisherType {
  /// Regular publisher who participates in ministry
  /// Can optionally become auxiliary pioneer for specific months
  publisher,

  /// Regular pioneer with ongoing commitment
  /// 50 hours per month, 600 hours per year
  regularPioneer,

  /// Special pioneer or missionary with full-time service
  /// 100 hours/month (men), 90-100 hours/month (women based on age)
  specialPioneer,
}

extension PublisherTypeExtension on PublisherType {
  /// Display name in Spanish for UI
  String get displayName {
    switch (this) {
      case PublisherType.publisher:
        return 'Publicador';
      case PublisherType.regularPioneer:
        return 'Precursor Regular';
      case PublisherType.specialPioneer:
        return 'Precursor Especial';
    }
  }

  /// Description of requirements and commitments
  String get description {
    switch (this) {
      case PublisherType.publisher:
        return 'Participo en la predicación regularmente';
      case PublisherType.regularPioneer:
        return '50 horas por mes, 600 horas al año';
      case PublisherType.specialPioneer:
        return '90-100 horas por mes según edad y género';
    }
  }

  /// Serialization key for storage
  String get key {
    switch (this) {
      case PublisherType.publisher:
        return 'publisher';
      case PublisherType.regularPioneer:
        return 'regularPioneer';
      case PublisherType.specialPioneer:
        return 'specialPioneer';
    }
  }

  /// Parse from storage key
  static PublisherType fromKey(String key) {
    switch (key) {
      case 'publisher':
        return PublisherType.publisher;
      case 'regularPioneer':
        return PublisherType.regularPioneer;
      case 'specialPioneer':
        return PublisherType.specialPioneer;
      default:
        throw ArgumentError('Unknown publisher type key: $key');
    }
  }
}
