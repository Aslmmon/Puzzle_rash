import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';

final progressStorageProvider = Provider<ProgressStorage>((ref) {
  return ProgressStorage();
});
