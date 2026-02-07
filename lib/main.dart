import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app.dart';
import 'core/services/user_profile_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for web and desktop platforms
  if (kIsWeb) {
    // Web platform
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    // Desktop platforms
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // For mobile (Android/iOS), use default sqflite implementation

  // Initialize UserProfileService
  await UserProfileService.instance.init();

  runApp(
    const ProviderScope(
      child: FlowApp(),
    ),
  );
}
