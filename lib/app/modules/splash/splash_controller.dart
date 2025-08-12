import 'dart:developer';

import 'package:get/get.dart';
import 'package:perfume_app/app/data/providers/api_provider.dart';
import 'package:perfume_app/app/data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = Get.put(
    AuthRepositoryImpl(apiProvider: ApiProvider()),
  );

  @override
  void onInit() {
    super.onInit();
    log('User is logged in: ');
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1));

    final isLoggedIn = await _authRepository.isLoggedIn();

    log('User is logged in: $isLoggedIn');

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
