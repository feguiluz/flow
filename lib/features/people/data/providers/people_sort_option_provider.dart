import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/features/people/data/models/people_sort_option.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';

part 'people_sort_option_provider.g.dart';

/// Holds and persists the user's chosen sort option for the people list.
/// Mirrors the [ThemeNotifier] pattern: reads from SharedPreferences on
/// build, writes through on every mutation.
@riverpod
class PeopleSortOptionNotifier extends _$PeopleSortOptionNotifier {
  late UserProfileService _service;

  @override
  PeopleSortOption build() {
    _service = ref.watch(userProfileServiceProvider);
    return _service.getPeopleSortOption();
  }

  Future<void> setSortOption(PeopleSortOption option) async {
    await _service.setPeopleSortOption(option);
    state = option;
  }
}
