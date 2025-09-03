import 'package:flutter/material.dart';

import 'memory_card_tile.dart';

/// Cards grid
class CardsGrid extends StatelessWidget {
  final List deck;
  final int cols;
  final Stream<int> matchedStream;
  final Function(int) onTap;

  const CardsGrid({
    super.key,
    required this.deck,
    required this.cols,
    required this.matchedStream,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (deck.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180/cols, // max card width
        mainAxisSpacing: 10,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: deck.length,
      itemBuilder: (context, index) {
        final card = deck[index];
        return MemoryCardTile(
          card: card,
          matchedStream: matchedStream,
          onTap: () => onTap(index),
        );
      },
    );
  }
}
