import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit.freezed.dart';
part 'visit.g.dart';

/// Visit model representing a return visit to an interested person
@freezed
class Visit with _$Visit {
  const factory Visit({
    required int? id,
    required int personId,
    required DateTime date,
    String? notes,
    required bool countedAsStudy,
    required DateTime createdAt,
  }) = _Visit;

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);
}
