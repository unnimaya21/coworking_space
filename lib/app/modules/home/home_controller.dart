import 'dart:developer';

import 'package:get/get.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

class HomeController extends GetxController {
  final GetHomeDataUseCase _getHomeDataUseCase = Get.find();

  final RxBool isLoading = true.obs;
  HomeDataEntity homeData = HomeDataEntity();
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;

    final result = await _getHomeDataUseCase.call();

    if (result.isLeft()) {
      // Optionally handle the error here, e.g., show a snackbar or call _setDefaultData()
      // final error = result.swap().getOrElse(() => 'Unknown error');
      // Get.snackbar('Error', error);
    } else {
      homeData = result.getOrElse(() => HomeDataEntity());
      searchQuery.value = 'new search';
      update();
    }

    log('Home data loaded: $homeData');
    // result.fold(
    //   (error) {
    //     Get.snackbar('Error', error);
    //     // Let _setDefaultData() handle the loading state change
    //     _setDefaultData();
    //   },
    //   (data) {
    //     homeData.value = data;
    //     // You can also handle the loading state here, or do it after the fold
    //   },
    // );
    // Place a single isLoading.value = false; outside the fold
    isLoading.value = false;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onScanPressed() {
    Get.snackbar('Scan', 'Scan functionality will be implemented');
  }

  void onBrandPressed(BrandEntity brand) {
    Get.snackbar('Brand', 'Selected: ${brand.name}');
  }

  void onCategoryPressed(CategoryEntity category) {
    Get.snackbar('Category', 'Selected: ${category.name}');
  }

  void onViewAllBrands() {
    Get.snackbar('Brands', 'View all brands');
  }

  void onViewAllCategories() {
    Get.snackbar('Categories', 'View all categories');
  }

  void onProductPressed(ProductEntity product) {}

  void onViewAllNewArrivals() {}
}
