import 'package:get/get.dart';
import 'package:coworking_space_app/app/modules/my_bookings/my_bookings_controller.dart';

class MyBookingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingsController>(() => MyBookingsController());
  }
}
