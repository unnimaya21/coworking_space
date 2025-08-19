import 'package:coworking_space_app/app/modules/filter/filter_controller.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
