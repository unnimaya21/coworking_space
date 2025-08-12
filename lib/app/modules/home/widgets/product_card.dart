import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perfume_app/app/core/utils/app_colors.dart';
import 'package:perfume_app/app/core/utils/storage_keys.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/home/home_controller.dart';
import 'package:perfume_app/app/modules/home/widgets/custom_button.dart';
import 'package:perfume_app/app/modules/home/widgets/quantity_selector.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class ProductCard extends StatefulWidget {
  final ProductEntity product;
  final Function(ProductEntity) onProductPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.onProductPressed,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  GetStorage storage = GetStorage();
  late bool isWishlisted;
  ProductEntity? savedItem;
  final HomeController homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    isWishlisted = widget.product.wishlisted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      List<dynamic> savedItems = storage.read(StorageKeys.products) ?? [];
      final List<ProductEntity> productsList =
          savedItems
              .map(
                (item) => ProductEntity.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      savedItem = productsList.firstWhereOrNull(
        (item) => item.id == widget.product.id,
      );
    });

    final double actualPrice =
        double.tryParse(widget.product.actualPrice ?? '0.0') ?? 0.0;
    final double price = double.tryParse(widget.product.price ?? '0.0') ?? 0.0;
    final int offerPercentage =
        ((actualPrice - price) / actualPrice * 100).round();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "% OFF" label
                  (offerPercentage > 0)
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.offerBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextWidget(
                          text: '$offerPercentage% OFF',
                          color: AppColors.offerTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                      : SizedBox.shrink(),
                  // Wishlist icon
                  Obx(() {
                    final savedProduct = homeController.products
                        .firstWhereOrNull(
                          (item) => item.id == widget.product.id,
                        );
                    return IconButton(
                      icon: Icon(
                        savedProduct?.wishlisted == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      color:
                          savedProduct?.wishlisted == true
                              ? Colors.red
                              : Colors.black,
                      onPressed:
                          () => homeController.toggleWishlist(widget.product),
                    );
                  }),
                ],
              ),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.image ?? '',
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
                  text: widget.product.name ?? 'No Name',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.prodTitle,
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
                        '${widget.product.currency ?? ''}${widget.product.actualPrice ?? '0.00'}',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.prodPrice,
                    isStriked: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextWidget(
                        text:
                            '${widget.product.currency ?? ''}${widget.product.price ?? '0.00'}',

                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 4),
                      TextWidget(
                        text: widget.product.unit ?? '',
                        fontSize: 12,
                        color: AppColors.black2,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Buttons Section
              Obx(() {
                final savedProduct = homeController.products.firstWhereOrNull(
                  (item) => item.id == widget.product.id,
                );
                final cartCount = savedProduct?.cartCount ?? 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: CustomButton(
                          text: 'RFQ',
                          textColor: Colors.black,
                          borderColor: AppColors.borderColor,
                          backgroundColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child:
                            (cartCount >= 1)
                                ? QuantitySelector(
                                  count: cartCount,
                                  onAdd:
                                      () => homeController.incrementCartCount(
                                        widget.product,
                                      ),
                                  onSubtract:
                                      () => homeController.decrementCartCount(
                                        widget.product,
                                      ),
                                )
                                : CustomButton(
                                  text: 'Add to Cart',
                                  textColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  onPressed:
                                      () => homeController.incrementCartCount(
                                        widget.product,
                                      ),
                                ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
