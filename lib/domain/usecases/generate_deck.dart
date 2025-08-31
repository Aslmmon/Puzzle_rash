import 'dart:math';

import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/domain/entities/memory_card.dart';
import 'package:puzzle_rush/domain/respositories/theme_repository.dart';

class GenerateDeck {
  final ThemeRepository repository;

  GenerateDeck({required this.repository});

  /// Generates a shuffled deck of MemoryCards for a given level
  List<MemoryCard> call(LevelConfig level) {
    // Number of pairs needed
    final int pairs = level.pairs;

    // Get labels/assets from repository
    final List<String> labels = repository.labelsForTheme(
      level.themeKey,
      pairs,
    );

    if (labels.length < pairs) {
      throw Exception("Not enough labels provided for level ${level.id}");
    }

    // Create cards: each label creates 2 cards
    List<MemoryCard> cards = [];
    for (int i = 0; i < pairs; i++) {
      cards.add(MemoryCard(pairId: i, label: labels[i]));
      cards.add(MemoryCard(pairId: i, label: labels[i]));
    }

    // Shuffle the deck
    cards.shuffle(Random());

    return cards;
  }
}
