// home_entities.dart

import 'package:perfume_app/app/data/models/home_data_model.dart';

class HomeDataEntity {
  final int? errorCode;
  final String? message;
  final List<HomeFieldEntity>? homeFields;

  HomeDataEntity({this.errorCode, this.message, this.homeFields});

  factory HomeDataEntity.fromModel(HomeDataModel model) {
    return HomeDataEntity(
      errorCode: model.errorCode,
      message: model.message,
      homeFields:
          model.homeFields
              ?.map((field) => HomeFieldEntity.fromModel(field))
              .toList(),
    );
  }
}

class DataEntity {
  final List<HomeFieldEntity>? homeFields;
  final int? notificationCount;

  DataEntity({this.homeFields, this.notificationCount});

  factory DataEntity.fromModel(Data model) {
    return DataEntity(
      homeFields:
          model.homeFields
              ?.map((field) => HomeFieldEntity.fromModel(field))
              .toList(),
      notificationCount: model.notificationCount,
    );
  }
}

class HomeFieldEntity {
  final String? type;
  final List<CarouselItemEntity>? carouselItems;
  final List<BrandEntity>? brands;
  final List<CategoryEntity>? categories;
  final List<ProductEntity>? products;
  final List<BannerItemEntity>? bannerItems;
  final RfqEntity? rfqItem;
  final FutureOrderEntity? futureOrderItem;

  HomeFieldEntity({
    this.type,
    this.carouselItems,
    this.brands,
    this.categories,
    this.products,
    this.bannerItems,
    this.rfqItem,
    this.futureOrderItem,
  });

  factory HomeFieldEntity.fromModel(HomeFieldModel model) {
    return HomeFieldEntity(
      type: model.type,
      carouselItems:
          model.carouselItems
              ?.map((item) => CarouselItemEntity.fromModel(item))
              .toList(),
      brands: model.brands?.map((item) => BrandEntity.fromModel(item)).toList(),
      categories:
          model.categories
              ?.map((item) => CategoryEntity.fromModel(item))
              .toList(),
      products:
          model.products?.map((item) => ProductEntity.fromModel(item)).toList(),
      rfqItem:
          model.type == 'rfq' && model.image != null
              ? RfqEntity(image: model.image)
              : null,
      futureOrderItem:
          model.type == 'future-order' && model.image != null
              ? FutureOrderEntity(image: model.image)
              : null,
      bannerItems:
          model.banners
              ?.map((item) => BannerItemEntity.fromModel(item))
              .toList(),
    );
  }
}

class CarouselItemEntity {
  final int? id;
  final String? image;
  final String? type;

  CarouselItemEntity({this.id, this.image, this.type});

  factory CarouselItemEntity.fromModel(CarouselItem model) {
    return CarouselItemEntity(
      id: model.id,
      image: model.image,
      type: model.type,
    );
  }
}

class BrandEntity {
  final int? id;
  final String? name;
  final String? image;

  BrandEntity({this.id, this.name, this.image});

  factory BrandEntity.fromModel(Brand model) {
    return BrandEntity(id: model.id, name: model.name, image: model.image);
  }
}

class CategoryEntity {
  final int? id;
  final String? name;
  final String? image;

  CategoryEntity({this.id, this.name, this.image});

  factory CategoryEntity.fromModel(Category model) {
    return CategoryEntity(id: model.id, name: model.name, image: model.image);
  }
}

class ProductEntity {
  final int? id;
  final String? image;
  final String? name;
  final String? currency;
  final String? unit;
  final bool? wishlisted;
  final bool? rfqStatus;
  final int? cartCount;
  final int? futureCartCount;
  final bool? hasStock;
  final String? price;
  final String? actualPrice;
  final String? offer;
  final List<dynamic>? offerPrices;

  ProductEntity({
    this.id,
    this.image,
    this.name,
    this.currency,
    this.unit,
    this.wishlisted,
    this.rfqStatus,
    this.cartCount,
    this.futureCartCount,
    this.hasStock,
    this.price,
    this.actualPrice,
    this.offer,
    this.offerPrices,
  });

  factory ProductEntity.fromModel(Product model) {
    return ProductEntity(
      id: model.id,
      image: model.image,
      name: model.name,
      currency: model.currency,
      unit: model.unit,
      wishlisted: model.wishlisted,
      rfqStatus: model.rfqStatus,
      cartCount: model.cartCount,
      futureCartCount: model.futureCartCount,
      hasStock: model.hasStock,
      price: model.price,
      actualPrice: model.actualPrice,
      offer: model.offer,
      offerPrices: model.offerPrices,
    );
  }
}

class BannerItemEntity {
  final String? image;
  final String? type;
  final int? id;

  BannerItemEntity({this.image, this.type, this.id});

  factory BannerItemEntity.fromModel(BannerItem model) {
    return BannerItemEntity(image: model.image, type: model.type, id: model.id);
  }
}

class RfqEntity {
  final String? image;

  RfqEntity({this.image});

  factory RfqEntity.fromModel(Rfq model) {
    return RfqEntity(image: model.image);
  }
}

class FutureOrderEntity {
  final String? image;

  FutureOrderEntity({this.image});

  factory FutureOrderEntity.fromModel(FutureOrder model) {
    return FutureOrderEntity(image: model.image);
  }
}
