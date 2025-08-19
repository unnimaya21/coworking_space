import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  // Use a Rx to hold the price range
  final Rx<RangeValues> selectedPrice = const RangeValues(0, 100).obs;

  // Rx variable to hold the selected city
  final Rxn<String> selectedCity = Rxn<String>();

  void setPriceRange(RangeValues values) {
    selectedPrice.value = values;
  }

  void setCity(String? city) {
    selectedCity.value = city;
  }
}
