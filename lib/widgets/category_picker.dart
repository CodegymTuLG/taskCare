import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryPicker extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final String Function(String) translate;

  const CategoryPicker({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.translate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('category_label'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...Category.predefined.map((category) => _buildCategoryChip(category)),
            _buildNoneChip(),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(Category category) {
    final isSelected = selectedCategory == category.key;
    return GestureDetector(
      onTap: () => onCategorySelected(category.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? category.color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: category.color, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: category.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: isSelected ? Colors.white : category.color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              category.getLocalizedName(translate),
              style: TextStyle(
                color: isSelected ? Colors.white : category.color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoneChip() {
    final isSelected = selectedCategory == null;
    return GestureDetector(
      onTap: () => onCategorySelected(null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade600 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade600, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          translate('category_none'),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
