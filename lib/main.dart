import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perfume_app/app/modules/splash/splash_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/providers/api_provider.dart';
import 'app/data/repositories/auth_repository_impl.dart';
import 'app/data/repositories/home_repository_impl.dart';
import 'app/domain/repositories/auth_repository.dart';
import 'app/domain/repositories/home_repository.dart';
import 'app/domain/usecases/login_usecase.dart';
import 'app/domain/usecases/get_home_data_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  log('App initialized');
  // Initialize dependencies
  _initDependencies();
  runApp(MyApp());
}

void _initDependencies() {
  Get.put<SplashController>(SplashController());

  log('Initializing dependencies');
  // Core
  Get.put<ApiProvider>(ApiProvider(), permanent: true);

  // Repositories
  Get.put<AuthRepository>(
    AuthRepositoryImpl(apiProvider: Get.find()),
    permanent: true,
  );
  Get.put<HomeRepository>(
    HomeRepositoryImpl(apiProvider: Get.find()),
    permanent: true,
  );

  // Use cases
  Get.put<LoginUseCase>(LoginUseCase(repository: Get.find()), permanent: true);
  Get.put<GetHomeDataUseCase>(
    GetHomeDataUseCase(repository: Get.find()),
    permanent: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Perfume App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,

      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
    );
  }
}
