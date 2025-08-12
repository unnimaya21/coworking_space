// Assumes you have a Product model class defined elsewhere
// e.g., class Product { final int id; final String image; ... }

import 'package:flutter/material.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/home/widgets/custom_button.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Safely parse the string prices to double for calculations
    final double actualPrice =
        double.tryParse(product.actualPrice ?? '0.0') ?? 0.0;
    final double price = double.tryParse(product.price ?? '0.0') ?? 0.0;
    final int offerPercentage =
        ((actualPrice - price) / actualPrice * 100).round();

    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "40% OFF" label
                  (offerPercentage > 0)
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextWidget(
                          text: '$offerPercentage% OFF',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : SizedBox.shrink(),
                  // Wishlist icon
                  Icon(
                    product.wishlisted == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        product.wishlisted == true ? Colors.red : Colors.black,
                  ),
                ],
              ),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image ?? '',
                    height: 120,
                    width: 90,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 120,
                          width: 90,
                          color: Colors.white,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Product Title
              Flexible(
                child: TextWidget(
                  text: product.name ?? 'No Name',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Price Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextWidget(
                    text:
                        '${product.currency ?? ''}${product.actualPrice ?? '0.00'}',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    isStriked: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextWidget(
                        text:
                            '${product.currency ?? ''}${product.price ?? '0.00'}',

                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 4),
                      TextWidget(
                        text: product.unit ?? '',
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Buttons Section
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'RFQ',
                      textColor: Colors.black,
                      borderColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'Add to Cart',
                    textColor: Colors.white,
                    backgroundColor: Colors.red,

                    onPressed: () {
                      // Handle Add to Cart button tap
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
