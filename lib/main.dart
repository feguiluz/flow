import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/user_profile_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize UserProfileService
  await UserProfileService.instance.init();

  runApp(
    const ProviderScope(
      child: FlowApp(),
    ),
  );
}
