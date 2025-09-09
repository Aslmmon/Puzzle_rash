// This provider holds the single instance of CoreConfig.
// It is initially set to `null` and must be overridden at the root of the app.
import 'package:codeleek_core/core/config/core_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coreConfigProvider = Provider<CoreConfig>((ref) {
  throw UnimplementedError(); // This ensures it must be overridden.
});
