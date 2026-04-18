import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

/// Person model representing an interested person or Bible study
@freezed
class Person with _$Person {
  const factory Person({
    int? id,
    required String name,
    String? phone,
    String? address,
    String? notes,
    required bool isBibleStudy,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}
