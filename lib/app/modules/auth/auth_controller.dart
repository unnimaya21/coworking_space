import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perfume_app/app/core/utils/storage_keys.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase = Get.find();
  final GetStorage _storage = GetStorage();

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
        _storage.remove(StorageKeys.products);
        _storage.remove(StorageKeys.authToken);
      },
      (user) {
        isLoading.value = false;
        Get.offAllNamed(AppRoutes.HOME);
      },
    );
  }
}
