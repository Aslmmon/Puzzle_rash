import 'package:flutter/material.dart';
import '../../domain/entities/memory_card.dart';

class MemoryCardTile extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;

  const MemoryCardTile({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: card.revealed || card.matched ? Colors.white : Colors.blue,
        child: Center(
          child: Text(
            card.revealed || card.matched ? card.label : '?',
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
