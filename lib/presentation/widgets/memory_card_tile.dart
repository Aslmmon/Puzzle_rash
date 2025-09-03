// lib/presentation/widgets/memory_card_tile.dart
import 'package:flutter/material.dart';
import 'package:puzzle_rush/domain/entities/memory_card.dart';

class MemoryCardTile extends StatefulWidget {
  final MemoryCard card;
  final VoidCallback onTap;

  const MemoryCardTile({super.key, required this.card, required this.onTap});

  @override
  State<MemoryCardTile> createState() => _MemoryCardTileState();
}

class _MemoryCardTileState extends State<MemoryCardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Animate the card if it is already revealed (e.g., after a rebuild)
    if (widget.card.revealed || widget.card.matched) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MemoryCardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger flip animation if the card's 'revealed' status changes
    if (widget.card.revealed != oldWidget.card.revealed) {
      if (widget.card.revealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    // Trigger a 'bounce' animation if the card becomes matched
    if (widget.card.matched && !oldWidget.card.matched) {
      // You can add a different animation for a match effect here
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isFlipped = _flipAnimation.value > 0.5;
          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Add perspective
                ..rotateY(
                  isFlipped
                      ? 3.14159 * (1 - _flipAnimation.value)
                      : 3.14159 * _flipAnimation.value,
                );

          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: isFlipped ? _buildFront() : _buildBack(),
          );
        },
      ),
    );
  }

  // Reusable widget builders for front and back faces of the card
  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(widget.card.label, style: const TextStyle(fontSize: 32)),
      ),
    );
  }

  Widget _buildBack() {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..rotateY(3.14159), // Rotate back side for seamless flip
      child: Container(
        decoration: BoxDecoration(
          color: widget.card.matched ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(Icons.help_outline, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
