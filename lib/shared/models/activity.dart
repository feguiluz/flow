import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Activity model representing daily ministry hours
@freezed
class Activity with _$Activity {
  const factory Activity({
    required int? id,
    required DateTime date,
    required double hours,
    String? notes,
    required DateTime createdAt,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
