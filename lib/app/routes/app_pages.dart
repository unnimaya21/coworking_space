import 'package:coworking_space_app/app/modules/filter/filter_bindings.dart';
import 'package:get/get.dart';
import 'package:coworking_space_app/app/modules/filter/filter_view.dart';
import 'package:coworking_space_app/app/modules/my_bookings/my_bookings.dart';
import 'package:coworking_space_app/app/modules/my_bookings/my_bookings_bindings.dart';

import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import 'app_routes.dart';

class AppPages {
  // static const INITIAL = AppRoutes.SPLASH;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.MY_BOOKINGS,
      page: () => const MyBookingsScreen(),
      binding: MyBookingsBindings(),
    ),
    GetPage(
      name: AppRoutes.FILTER,
      page: () => const FilterScreen(),
      binding: FilterBindings(),
    ),
  ];
}
