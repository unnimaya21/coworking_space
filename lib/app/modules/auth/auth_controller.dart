import 'package:get/get.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase = Get.find();

  final RxBool isLoading = false.obs;

  Future<void> performAnonymousLogin() async {
    isLoading.value = true;

    final result = await _loginUseCase.call(
      deviceToken: 'test_token',
      deviceType: 1,
    );

    result.fold(
      (error) {
        Get.snackbar('Error', error);
        isLoading.value = false;
      },
      (user) {
        isLoading.value = false;
        Get.offAllNamed(AppRoutes.HOME);
      },
    );
  }
}
