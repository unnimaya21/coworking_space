import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perfume_app/app/core/utils/storage_keys.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

class HomeController extends GetxController {
  final GetHomeDataUseCase _getHomeDataUseCase = Get.find();

  final RxBool isLoading = true.obs;
  HomeDataEntity homeData = HomeDataEntity();
  final RxString searchQuery = ''.obs;
  var products = <ProductEntity>[].obs;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
    _loadProductsFromStorage();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;

    final result = await _getHomeDataUseCase.call();

    if (result.isLeft()) {
    } else {
      homeData = result.getOrElse(() => HomeDataEntity());
      update();
    }

    log('Home data loaded: $homeData');

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

  void onProductPressed(ProductEntity product) {
    final GetStorage storage = GetStorage();

    // Read the existing list of maps from storage
    final List<dynamic> savedItems = storage.read(StorageKeys.products) ?? [];

    // Convert the list of maps back to a list of ProductEntity
    final List<ProductEntity> productsList =
        savedItems
            .map((item) => ProductEntity.fromJson(item as Map<String, dynamic>))
            .toList();

    // Check if the product already exists
    if (productsList.any((item) => item.id == product.id)) {
      // If it exists, find it and update the cart count
      final existingProduct = productsList.firstWhere(
        (item) => item.id == product.id,
      );
      existingProduct.cartCount = (existingProduct.cartCount ?? 0) + 1;
    } else {
      // If it doesn't exist, add the new product
      productsList.add(product);
    }

    // Convert the updated list of ProductEntity back to a list of maps
    final List<Map<String, dynamic>> itemsToSave =
        productsList.map((item) => item.toJson()).toList();

    // Write the list of maps to GetStorage
    storage.write(StorageKeys.products, itemsToSave);
    log('items: $itemsToSave');
  }

  void onViewAllNewArrivals() {}

  void _loadProductsFromStorage() {
    final List<dynamic> savedItems = _storage.read(StorageKeys.products) ?? [];
    products.value =
        savedItems
            .map((item) => ProductEntity.fromJson(item as Map<String, dynamic>))
            .toList();
  }

  void incrementCartCount(ProductEntity product) {
    // Find the product in the reactive list
    final existingProductIndex = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingProductIndex != -1) {
      // If the product is in the list, increment its count
      final updatedProduct = products[existingProductIndex];
      updatedProduct.cartCount = (updatedProduct.cartCount ?? 0) + 1;
      products[existingProductIndex] = updatedProduct;
    } else {
      // If it's a new product, set count to 1 and add it
      product.cartCount = 1;
      products.add(product);
    }
    _saveToStorage();
  }

  void decrementCartCount(ProductEntity product) {
    final existingProductIndex = products.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingProductIndex != -1) {
      final updatedProduct = products[existingProductIndex];
      if ((updatedProduct.cartCount ?? 0) > 1) {
        updatedProduct.cartCount = updatedProduct.cartCount! - 1;
        products[existingProductIndex] = updatedProduct;
      } else {
        // If the count is 1, remove the product from the list
        products.removeAt(existingProductIndex);
      }
      _saveToStorage();
    }
  }

  void toggleWishlist(ProductEntity product) {
    final existingProductIndex = products.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingProductIndex != -1) {
      final updatedProduct = products[existingProductIndex];
      updatedProduct.wishlisted = !(updatedProduct.wishlisted ?? false);
      products[existingProductIndex] = updatedProduct;
    } else {
      product.wishlisted = true;
      products.add(product);
    }
    _saveToStorage();
  }

  void _saveToStorage() {
    final List<Map<String, dynamic>> itemsToSave =
        products.map((item) => item.toJson()).toList();
    _storage.write(StorageKeys.products, itemsToSave);
  }
}
