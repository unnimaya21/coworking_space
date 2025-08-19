import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> goToHome() async {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.HOME);
    });
  }
}
