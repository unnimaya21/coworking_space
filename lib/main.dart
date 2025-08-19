import 'dart:developer';

import 'package:coworking_space_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:coworking_space_app/app/modules/splash/splash_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/providers/api_provider.dart';
import 'app/data/repositories/home_repository_impl.dart';
import 'app/domain/repositories/home_repository.dart';
import 'app/domain/usecases/get_home_data_usecase.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initDependenciesCoreOnly();
  final FlutterLocalNotificationsPlugin flnp =
      FlutterLocalNotificationsPlugin();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationService = Get.put<NotificationService>(
    NotificationService(),
    permanent: true,
  );

  // Initialize plugin + permissions ONCE
  await notificationService.init();
  await notificationService.requestAndroidPermissions(
    // POST_NOTIFICATIONS
    notificationService.flutterLocalNotificationsPlugin,
  );
  // (optional) exact alarms if you need exact scheduling:
  await notificationService.ensureNotificationPerms(
    notificationService.flutterLocalNotificationsPlugin,
  );
  final android =
      flnp
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
  await android?.requestNotificationsPermission();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'booking_live', // id
    'Booking Live Alerts', // name shown in Settings
    description: 'Time-sensitive booking reminders.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );
  await android?.createNotificationChannel(channel);
  // Quick sanity test: 10s local notification
  await notificationService.testIn10Seconds(notificationService);
  await notificationService.scheduleResilient(
    flnp: notificationService.flutterLocalNotificationsPlugin,
    id: 101,
    title: 'Booking Reminder',
    body: 'Starts in 10 minutes',
    when: DateTime.now().add(const Duration(seconds: 15)),
  );

  // FCM background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FCM foreground → reuse the SAME instance
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final svc = Get.find<NotificationService>();
    await svc.requestAndroidPermissions(svc.flutterLocalNotificationsPlugin);
    final pending =
        await notificationService.flutterLocalNotificationsPlugin
            .pendingNotificationRequests();
    log('Pending: ${pending.map((e) => e.id).toList()}');
    // Check if the message contains a notification payload
    if (message.notification != null) {
      // Use the service to show a local notification
      notificationService.showNotification(
        id: 0, // You can use a specific ID if you have a way to generate them
        title: message.notification!.title!,
        body: message.notification!.body!,
      );
    }
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');
  });

  // Request notification permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(MyApp());
}

mixin DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyD1OnmjblicXLy3TRxnTbaSr57k9HUY9cM',
      appId: '1:285171832081:android:26b30959abe991da83e8b0',
      messagingSenderId: '285171832081',
      projectId: 'coworking-space-app-f3335',
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

  // SplashController
  Get.put<SplashController>(SplashController());
  // ⛔️ Do NOT create NotificationService here; we create+await it in main()
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Coworking Space App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,

      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
    );
  }
}
