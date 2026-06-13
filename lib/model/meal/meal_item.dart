import 'package:flutter/material.dart';

import '../../data/dtos/menu_dto.dart';

class MealItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final List<String> tags;
  final MealSession session;
  final String? imageUrl;
  final String? localImagePath;
  final int colorSeed;

  const MealItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.tags,
    required this.session,
    this.imageUrl,
    this.localImagePath,
    this.colorSeed = 0,
  });

  factory MealItem.fromDto(MenuItemDto dto, {int colorSeed = 0}) => MealItem(
        id: dto.id,
        name: dto.name,
        description: dto.description,
        price: dto.price,
        rating: dto.rating,
        tags: dto.tags,
        session: MealSession.fromString(dto.session),
        imageUrl: dto.imageUrl,
        colorSeed: colorSeed,
      );
}

enum MealSession {
  breakfast,
  lunch,
  drinks;

  static MealSession fromString(String value) => switch (value) {
        'lunch' => MealSession.lunch,
        'drinks' => MealSession.drinks,
        _ => MealSession.breakfast,
      };

  String get label => switch (this) {
        MealSession.breakfast => 'Breakfast',
        MealSession.lunch => 'Lunch',
        MealSession.drinks => 'Drinks',
      };
}

// ── Visual helpers (used by UI, kept co-located with the model) ───────────────

const List<List<Color>> kMealGradients = [
  [Color(0xFFF8DFAF), Color(0xFFF9F4D7)],
  [Color(0xFFFFCDD2), Color(0xFFFFEBEE)],
  [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
  [Color(0xFFC8E6C9), Color(0xFFE8F5E9)],
  [Color(0xFFE1BEE7), Color(0xFFF3E5F5)],
];

const List<IconData> kMealIcons = [
  Icons.ramen_dining,
  Icons.lunch_dining,
  Icons.local_cafe,
  Icons.rice_bowl,
  Icons.egg_alt,
];
