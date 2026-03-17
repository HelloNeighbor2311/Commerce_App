import 'package:flutter/material.dart';

class CategoryGridScroller extends StatelessWidget {
  const CategoryGridScroller({
    super.key,
    required this.categories,
    required this.selectedCategoryTag,
    required this.onCategorySelected,
  });

  final List<Map<String, String>> categories;
  final String selectedCategoryTag;
  final Function(String) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
