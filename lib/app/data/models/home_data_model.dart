import 'dart:developer';

class HomeDataModel {
  int? errorCode;
  String? message;
  Data? data;
  List<HomeFieldModel>? homeFields;

  HomeDataModel({this.errorCode, this.message, this.data, this.homeFields});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    // log('HomeDataModel JSON: ${json.toString()}');
    errorCode = json['error_code'];
    message = json['message'];
    homeFields =
        (json['home_fields'] as List?)
            ?.map((item) => HomeFieldModel.fromJson(item))
            .toList();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    log('data: ${homeFields.toString()}');
  }
}

class Data {
  List<HomeFieldModel>? homeFields;
  int? notificationCount;

  Data({this.homeFields, this.notificationCount});

  Data.fromJson(Map<String, dynamic> json) {
    log('Data JSON: ${json.toString()}');
    if (json['home_fields'] != null) {
      homeFields = <HomeFieldModel>[];
      for (var fieldJson in json['home_fields']) {
        homeFields!.add(HomeFieldModel.fromJson(fieldJson));
      }
    }
    notificationCount = json['notification_count'];
  }
}

class HomeFieldModel {
  String? type;
  List<CarouselItem>? carouselItems;
  List<Brand>? brands;
  List<Category>? categories;
  List<Product>? products;
  BannerItem? banner; // Added for single banner
  List<BannerItem>? banners; // For the banner-grid type
  String? image; // For rfq and future-order types
  int? collectionId;
  String? name;

  HomeFieldModel({
    this.type,
    this.carouselItems,
    this.brands,
    this.categories,
    this.products,
    this.banner,
    this.banners,
    this.image,
    this.collectionId,
    this.name,
  });

  HomeFieldModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];

    // Handle different field types
    if (json['carousel_items'] != null) {
      carouselItems =
          (json['carousel_items'] as List)
              .map((item) => CarouselItem.fromJson(item))
              .toList();
    }
    if (json['brands'] != null) {
      brands =
          (json['brands'] as List).map((item) => Brand.fromJson(item)).toList();
    }
    if (json['categories'] != null) {
      categories =
          (json['categories'] as List)
              .map((item) => Category.fromJson(item))
              .toList();
    }
    if (json['products'] != null) {
      products =
          (json['products'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
    }
    // Handle the single banner field type
    if (json['banner'] != null) {
      banner = BannerItem.fromJson(json['banner']);
    }
    // Handle the banner-grid field type
    if (json['banners'] != null) {
      banners =
          (json['banners'] as List)
              .map((item) => BannerItem.fromJson(item))
              .toList();
    }
    // Handle the rfq and future-order fields which just have an image
    if (json['image'] != null) {
      image = json['image'];
    }
    if (json['collection_id'] != null) {
      collectionId = json['collection_id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
  }
}

class CarouselItem {
  int? id;
  String? image;
  String? type;

  CarouselItem({this.id, this.image, this.type});

  CarouselItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['type'] = type;
    return data;
  }
}

class Brand {
  int? id;
  String? name;
  String? image;

  Brand({this.id, this.name, this.image});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;

  Category({this.id, this.name, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Product {
  int? id;
  String? image;
  String? name;
  String? currency;
  String? unit;
  bool? wishlisted;
  bool? rfqStatus;
  int? cartCount;
  int? futureCartCount;
  bool? hasStock;
  String? price;
  String? actualPrice;
  String? offer;
  List<dynamic>? offerPrices;

  Product({
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

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    currency = json['currency'];
    unit = json['unit'];
    wishlisted = json['wishlisted'];
    rfqStatus = json['rfq_status'];
    cartCount = json['cart_count'];
    futureCartCount = json['future_cart_count'];
    hasStock = json['has_stock'];
    price = json['price'];
    actualPrice = json['actual_price'];
    offer = json['offer'];
    if (json['offer_prices'] != null) {
      offerPrices = <dynamic>[];
      json['offer_prices'].forEach((v) {
        offerPrices!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['currency'] = currency;
    data['unit'] = unit;
    data['wishlisted'] = wishlisted;
    data['rfq_status'] = rfqStatus;
    data['cart_count'] = cartCount;
    data['future_cart_count'] = futureCartCount;
    data['has_stock'] = hasStock;
    data['price'] = price;
    data['actual_price'] = actualPrice;
    data['offer'] = offer;
    if (offerPrices != null) {
      data['offer_prices'] = offerPrices!.map((v) => v).toList();
    }
    return data;
  }
}

class BannerItem {
  String? image;
  String? type;
  int? id;

  BannerItem({this.image, this.type, this.id});

  BannerItem.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['type'] = type;
    data['id'] = id;
    return data;
  }
}

class Rfq {
  String? image;

  Rfq({this.image});

  Rfq.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }
}

class FutureOrder {
  String? image;

  FutureOrder({this.image});

  FutureOrder.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }
}
