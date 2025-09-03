// lib/presentation/providers/progress_storage_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/cache/progress_storage.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

final progressStorageProvider = Provider<ProgressStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.when(
    data: (prefs) => ProgressStorage(prefs),
    loading:
        () => ProgressStorage(
          throw Exception('Shared Preferences not initialized'),
        ),
    error:
        (err, stack) =>
            ProgressStorage(throw Exception('Shared Preferences error')),
  );
});
