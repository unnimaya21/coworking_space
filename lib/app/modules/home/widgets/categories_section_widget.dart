import 'package:flutter/material.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class CategoriesSectionWidget extends StatelessWidget {
  final List<CategoryEntity> categories;
  final Function(CategoryEntity) onCategoryPressed;
  final VoidCallback onViewAll;

  const CategoriesSectionWidget({
    super.key,
    required this.categories,
    required this.onCategoryPressed,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: 'Our Categories',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: onViewAll,
              child: TextWidget(
                text: 'View All',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                isUnderlined: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () => onCategoryPressed(category),
              child: Column(
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getColorFromHex(category.name!),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(category.image!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    text: category.name!,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getColorFromHex(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey[200]!;
    }
  }
}
