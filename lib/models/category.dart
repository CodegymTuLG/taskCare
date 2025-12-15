import 'package:flutter/material.dart';

class Category {
  final String key;
  final IconData icon;
  final Color color;

  const Category(this.key, this.icon, this.color);

  static const List<Category> predefined = [
    Category('work', Icons.work, Color(0xFF2196F3)),
    Category('personal', Icons.person, Color(0xFF4CAF50)),
    Category('shopping', Icons.shopping_cart, Color(0xFFFFC107)),
    Category('study', Icons.school, Color(0xFF9C27B0)),
  ];

  static Category? fromKey(String? key) {
    if (key == null) return null;
    try {
      return predefined.firstWhere((cat) => cat.key == key);
    } catch (e) {
      return null;
    }
  }

  String getLocalizedName(String Function(String) translate) {
    return translate('category_$key');
  }
}
