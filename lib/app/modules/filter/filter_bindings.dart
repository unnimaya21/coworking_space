import 'package:get/get.dart';
import 'package:coworking_space_app/app/modules/filter/filter_controller.dart';

class FilterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
