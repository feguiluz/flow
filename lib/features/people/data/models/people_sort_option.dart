/// Ways the people list (interested persons + Bible studies) can be ordered.
enum PeopleSortOption {
  /// Name A → Z, case-insensitive.
  alphabetical,

  /// Most recent visit first; people without visits go to the end.
  /// Ties (and the no-visits group) are broken alphabetically.
  lastVisitDesc,

  /// Most recently created first; ties broken alphabetically.
  createdAtDesc;

  /// Default ordering applied when no preference has been stored yet.
  static const PeopleSortOption defaultOption = PeopleSortOption.alphabetical;

  /// Spanish label shown to the user in the sort sheet.
  String get displayLabel {
    switch (this) {
      case PeopleSortOption.alphabetical:
        return 'Alfabético';
      case PeopleSortOption.lastVisitDesc:
        return 'Última revisita';
      case PeopleSortOption.createdAtDesc:
        return 'Fecha de creación';
    }
  }
}
