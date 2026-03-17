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

  static const Map<String, IconData> _iconMap = <String, IconData>{
    'smartphone': Icons.smartphone,
    'laptop_mac': Icons.laptop_mac,
    'face_retouching_natural': Icons.face_retouching_natural,
    'home': Icons.home,
    'checkroom': Icons.checkroom,
    'dry_cleaning': Icons.dry_cleaning,
    'directions_run': Icons.directions_run,
    'watch': Icons.watch,
    'diamond': Icons.diamond,
    'directions_car': Icons.directions_car,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 8,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> category = categories[index];
          final IconData icon = _iconMap[category['icon']] ?? Icons.apps;
          final String title = category['title'] ?? '';
          final String tag = category['tag'] ?? 'all';
          
          final bool isSelected = selectedCategoryTag == tag;

          return GestureDetector(
            onTap: () => onCategorySelected(tag),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF0EC) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF5722) : Colors.black12,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFFFF5722).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFFFFF0EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFFFF5722), size: 18),
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? const Color(0xFFFF5722) : Colors.black87,
                        fontSize: 10,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}