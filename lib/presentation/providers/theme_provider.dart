import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/domain/respositories/theme_repository.dart';
import '../../data/repositories/theme_repository_impl.dart';

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepositoryImpl();
});
