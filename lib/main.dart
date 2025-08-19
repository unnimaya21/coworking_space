import 'dart:developer';
import 'package:coworking_space_app/app/core/theme/app_theme.dart';
import 'package:coworking_space_app/app/data/providers/api_provider.dart';
import 'package:coworking_space_app/app/data/repositories/home_repository_impl.dart';
import 'package:coworking_space_app/app/domain/repositories/home_repository.dart';
import 'package:coworking_space_app/app/domain/usecases/get_home_data_usecase.dart';
import 'package:coworking_space_app/app/modules/auth/auth_controller.dart';
import 'package:coworking_space_app/app/modules/splash/splash_controller.dart';
import 'package:coworking_space_app/app/routes/app_pages.dart';
import 'package:coworking_space_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'services/notification_service.dart';

// If you have firebase_options.dart, import and use it here.
// For brevity, using inline options like you had:
mixin DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
    apiKey: 'AIzaSyD1OnmjblicXLy3TRxnTbaSr57k9HUY9cM',
    appId: '1:285171832081:android:26b30959abe991da83e8b0',
    messagingSenderId: '285171832081',
    projectId: 'coworking-space-app-f3335',
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  log('BG FCM: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  _initDependenciesCoreOnly();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // ONE NotificationService instance for the whole app
  final notificationService = Get.put<NotificationService>(
    NotificationService(),
    permanent: true,
  );
  await notificationService.init();
  await notificationService.requestAndroidPermissions();

  // FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notif = message.notification;
    if (notif != null) {
      await notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notif.title ?? 'Notification',
        body: notif.body ?? '',
      );
    }
  });

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Coworking Space App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.routes,

      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
    );
  }
}

void _initDependenciesCoreOnly() {
  // Core / API
  Get.put<ApiProvider>(ApiProvider(), permanent: true);

  // Repositories
  Get.put<HomeRepository>(
    HomeRepositoryImpl(apiProvider: Get.find()),
    permanent: true,
  );

  // Use cases
  Get.put<GetHomeDataUseCase>(
    GetHomeDataUseCase(repository: Get.find()),
    permanent: true,
  );

  Get.put<SplashController>(SplashController());
  Get.put<AuthController>(AuthController());
}
