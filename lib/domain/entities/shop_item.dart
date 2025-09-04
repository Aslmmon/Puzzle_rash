// lib/domain/entities/shop_item.dart
import 'package:flutter/material.dart';

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int cost;
  final IconData icon;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.icon,
  });
}
