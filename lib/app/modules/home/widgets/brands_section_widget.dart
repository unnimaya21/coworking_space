import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class BrandsSectionWidget extends StatelessWidget {
  final List<BrandEntity> brands;
  final Function(BrandEntity) onBrandPressed;
  final VoidCallback onViewAll;

  const BrandsSectionWidget({
    super.key,
    required this.brands,
    required this.onBrandPressed,
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
              text: 'Shop By Brands',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: onViewAll,
              child: TextWidget(
                text: 'View All',
                fontSize: 14,
                isUnderlined: true,

                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == brands.length - 1 ? 0 : 16,
                ),
                child: GestureDetector(
                  onTap: () => onBrandPressed(brand),
                  child: Container(
                    width: 130,
                    height: 104,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                          brand.image!.startsWith('http')
                              ? CachedNetworkImage(
                                imageUrl: brand.image!,
                                width: 104,
                                height: 130,
                                fit: BoxFit.contain,
                                placeholder:
                                    (context, url) => Container(
                                      width: 104,
                                      height: 130,
                                      color: Colors.grey[200],
                                    ),
                                errorWidget:
                                    (context, url, error) => TextWidget(
                                      text: brand.name!,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                              : TextWidget(
                                text: brand.name!,

                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
