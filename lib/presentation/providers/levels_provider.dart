import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/level_config.dart';

final levelsProvider = Provider<List<LevelConfig>>((ref) {
  return [
    LevelConfig(id: 1, rows: 2, cols: 2, themeKey: 'palestine'),
    LevelConfig(id: 2, rows: 2, cols: 4, themeKey: 'palestine'),
    LevelConfig(id: 3, rows: 4, cols: 4, themeKey: 'islam'),
    LevelConfig(id: 4, rows: 4, cols: 6, themeKey: 'palestine'),
    LevelConfig(id: 5, rows: 6, cols: 6, themeKey: 'islam'),
  ];
});


