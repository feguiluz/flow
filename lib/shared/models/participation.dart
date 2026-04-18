import 'package:freezed_annotation/freezed_annotation.dart';

part 'participation.freezed.dart';
part 'participation.g.dart';

/// Monthly participation record for publishers without auxiliary pioneer goal
///
/// Publishers who don't have an auxiliary pioneer goal for a month can only
/// mark whether they participated in ministry that month (yes/no checkbox).
/// They cannot log hours unless they set an auxiliary pioneer goal.
@freezed
class Participation with _$Participation {
  const factory Participation({
    /// Database ID
    int? id,

    /// Year (e.g., 2026)
    required int year,

    /// Month (1-12)
    required int month,

    /// Whether the publisher participated in ministry this month
    required bool participated,

    /// When this participation was created/updated
    required DateTime createdAt,
  }) = _Participation;

  factory Participation.fromJson(Map<String, dynamic> json) =>
      _$ParticipationFromJson(json);
}
