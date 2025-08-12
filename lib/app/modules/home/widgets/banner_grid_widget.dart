import 'package:flutter/material.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class BannerGridWidget extends StatelessWidget {
  final List<BannerItemEntity> items;
  final VoidCallback onShopNow;

  const BannerGridWidget({
    super.key,
    required this.items,
    required this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 1.0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,

            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(product.image!, fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: TextWidget(
                          text: 'Shop Now',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          isUnderlined: true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
