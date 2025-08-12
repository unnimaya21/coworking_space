// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/home/widgets/product_card.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class NewArrivalsWidget extends StatelessWidget {
  final List<ProductEntity> newArrivals;
  final Function(ProductEntity) onProductPressed;
  final VoidCallback onViewAll;
  String title;

  NewArrivalsWidget({
    super.key,
    required this.newArrivals,
    required this.onProductPressed,
    required this.onViewAll,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: title, fontSize: 18, fontWeight: FontWeight.w600),
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
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 1.0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,

            itemCount: newArrivals.length,
            itemBuilder: (context, index) {
              final product = newArrivals[index];
              return ProductCard(
                product: product,
                onProductPressed: onProductPressed,
              );
            },
          ),
        ),
      ],
    );
  }
}
