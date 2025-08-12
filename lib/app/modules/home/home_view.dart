import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perfume_app/app/domain/entities/home_data_entity.dart';
import 'package:perfume_app/app/modules/home/widgets/banner_grid_widget.dart';
import 'package:perfume_app/app/modules/home/widgets/brands_section_widget.dart';
import 'package:perfume_app/app/modules/home/widgets/categories_section_widget.dart';
import 'package:perfume_app/app/modules/home/widgets/image_carousel.dart';
import 'package:perfume_app/app/modules/home/widgets/new_arrivals_widget.dart';
import 'package:perfume_app/app/modules/home/widgets/request_quote_widget.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'home_controller.dart';
import 'widgets/search_bar_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }
          final List<HomeFieldEntity> homeFields =
              controller.homeData.homeFields ?? [];

          return RefreshIndicator(
            onRefresh: controller.loadHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  SearchBarWidget(
                    onChanged: controller.onSearchChanged,
                    onScanPressed: controller.onScanPressed,
                  ),
                  const SizedBox(height: 24),
                  if (homeFields.isNotEmpty)
                    PerfumeBanner(
                      items:
                          homeFields
                              .firstWhere((field) => field.type == 'carousel')
                              .carouselItems ??
                          [],
                    ),

                  const SizedBox(height: 32),
                  if (homeFields.isNotEmpty)
                    BrandsSectionWidget(
                      brands:
                          homeFields
                              .firstWhere((field) => field.type == 'brands')
                              .brands ??
                          [],
                      onBrandPressed: (brand) {
                        controller.onBrandPressed(brand);
                        return null;
                      },
                      onViewAll: controller.onViewAllBrands,
                    ),
                  const SizedBox(height: 32),
                  if (homeFields.isNotEmpty)
                    CategoriesSectionWidget(
                      categories:
                          homeFields
                              .firstWhere((field) => field.type == 'category')
                              .categories ??
                          [],
                      onCategoryPressed: controller.onCategoryPressed,
                      onViewAll: controller.onViewAllCategories,
                    ),

                  RequestQuoteWidget(),
                  if (homeFields.isNotEmpty)
                    NewArrivalsWidget(
                      title: 'New Arrivals',
                      newArrivals:
                          homeFields
                              .firstWhere((field) => field.type == 'collection')
                              .products ??
                          [],
                      onProductPressed: (product) {
                        controller.onProductPressed(product);
                      },
                      onViewAll: () {
                        controller.onViewAllNewArrivals();
                      },
                    ),
                  BannerGridWidget(
                    items:
                        homeFields
                            .firstWhere((field) => field.type == 'banner-grid')
                            .bannerItems ??
                        [],
                    onShopNow: () {},
                  ),
                  if (homeFields.isNotEmpty)
                    NewArrivalsWidget(
                      title: 'Latest Products',
                      newArrivals:
                          homeFields
                              .firstWhere((field) => field.type == 'collection')
                              .products ??
                          [],
                      onProductPressed: (product) {
                        controller.onProductPressed(product);
                      },
                      onViewAll: () {
                        controller.onViewAllNewArrivals();
                      },
                    ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/banner2.png',
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 180,
                    ),
                  ),
                  if (homeFields.isNotEmpty)
                    NewArrivalsWidget(
                      title: 'New Arrivals',
                      newArrivals:
                          homeFields
                              .firstWhere((field) => field.type == 'collection')
                              .products ??
                          [],
                      onProductPressed: (product) {
                        controller.onProductPressed(product);
                      },
                      onViewAll: () {
                        controller.onViewAllNewArrivals();
                      },
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: 'Welcome!',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,

                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
