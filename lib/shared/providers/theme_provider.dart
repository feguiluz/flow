import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/user_profile_service.dart';
import 'user_profile_provider.dart';

part 'theme_provider.g.dart';

/// Provider for theme mode (light/dark/system)
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  late UserProfileService _service;

  @override
  ThemeMode build() {
    _service = ref.watch(userProfileServiceProvider);
    return _service.getThemeMode();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await _service.setThemeMode(mode);
    state = mode;
  }
}
