import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FlutterLocalNotificationsPlugin flnp =
      FlutterLocalNotificationsPlugin();
  NotificationDetails kLoudDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'booking_live',
      'Booking Live Alerts',
      channelDescription: 'Time-sensitive booking reminders.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    ),
  );

  Future<void> init() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        // Handle notification tap
      },
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Sanity: avoid “past” times
    if (scheduledDate.isBefore(DateTime.now())) {
      // add a few seconds so we don’t error out
      scheduledDate = DateTime.now().add(const Duration(seconds: 5));
    }

    // final details = NotificationDetails(android: androidDetails);

    final tzTime = tz.TZDateTime.from(scheduledDate, tz.local);

    final exactAllowed = await ensureExactAlarmPerm(
      flutterLocalNotificationsPlugin,
    );

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        kLoudDetails,
        androidScheduleMode:
            exactAllowed
                ? AndroidScheduleMode.alarmClock
                : AndroidScheduleMode.inexact,
      );
      log('Notification scheduled for $scheduledDate');
      final pending = await flnp.pendingNotificationRequests();
      log(
        'PENDING: ${pending.map((e) => {'id': e.id, 'title': e.title, 'time': e.title}).toList()}',
      );
      final android =
          flnp
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final enabled = await android?.areNotificationsEnabled() ?? true;
      final channels = await android?.getNotificationChannels() ?? [];

      log('enabled=$enabled');
      log('channels=${channels.map((c) => {'id': c.id, 'imp': c.importance})}');
      log('pending=${pending.map((e) => {'id': e.id, 'title': e.title})}');
    } catch (e) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        kLoudDetails,
        androidScheduleMode:
            exactAllowed
                ? AndroidScheduleMode.alarmClock
                : AndroidScheduleMode.inexact,
      );
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'booking_live', // Make sure this channel ID is the same as the one used in Firebase console
      'Booking Reminders',
      channelDescription: 'Reminders for your coworking space bookings.',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x', // Optional payload for handling taps
    );
  }

  Future<void> requestAndroidPermissions(
    FlutterLocalNotificationsPlugin flnp,
  ) async {
    final android =
        flnp
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    // Android 13+ notifications runtime permission
    await android?.requestNotificationsPermission();

    // Exact alarms (Android 12+). This opens the “Alarms & reminders” special access screen.
    final canExact = await android?.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      await android?.requestExactAlarmsPermission();
    }
  }

  Future<bool> ensureNotificationPerms(
    FlutterLocalNotificationsPlugin flnp,
  ) async {
    final android =
        flnp
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    // Android 13+ notifications permission
    final notifGranted =
        await android?.requestNotificationsPermission() ?? true;
    return notifGranted;
  }

  /// Returns true iff OS allows exact alarms for your app.
  Future<bool> ensureExactAlarmPerm(
    FlutterLocalNotificationsPlugin flnp,
  ) async {
    if (!Platform.isAndroid) return true;
    final android =
        flnp
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    bool allowed = await android?.canScheduleExactNotifications() ?? false;
    if (!allowed) {
      // Try the plugin’s helper (opens the system screen).
      await android?.requestExactAlarmsPermission();
      // Re-check
      allowed = await android?.canScheduleExactNotifications() ?? false;
    }
    return allowed;
  }

  /// As a fallback, open the OS settings via an explicit intent.
  /// Use this if requestExactAlarmsPermission() is a no-op on some OEMs.
  final MethodChannel _platform = MethodChannel('app.exact_alarm.settings');

  Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _platform.invokeMethod('open_exact_alarm_settings');
    } catch (_) {}
  }

  Future<void> testIn10Seconds(NotificationService svc) async {
    final now = DateTime.now().add(const Duration(seconds: 10));
    await svc.scheduleNotification(
      id: 9990,
      title: 'Test (10s)',
      body: 'If you see this, scheduling works.',
      scheduledDate: now,
    );
  }

  Future<void> scheduleResilient({
    required FlutterLocalNotificationsPlugin flnp,
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    // Nudge future to avoid “past” drop
    if (!when.isAfter(DateTime.now().add(const Duration(seconds: 2)))) {
      when = DateTime.now().add(const Duration(seconds: 10));
    }

    final tzWhen = tz.TZDateTime.from(when, tz.local);

    // Check permissions & channel state
    final android =
        flnp
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    final enabled = await android?.areNotificationsEnabled() ?? true;

    if (!enabled) {
      // App notifications are OFF at the OS level — must be enabled by user
      // Consider showing a dialog and deep-linking to notification settings.
    }

    // Try for exact alarms (Android 12+). If not allowed, we’ll fall back.
    bool canExact = await android?.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      await android?.requestExactAlarmsPermission();
      canExact = await android?.canScheduleExactNotifications() ?? false;
    }

    try {
      await flnp.zonedSchedule(
        id,
        title,
        body,
        tzWhen,
        kLoudDetails,
        androidScheduleMode:
            canExact
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.inexact,
      );
    } catch (e) {
      // Fallback to inexact if device/OEM still rejects exact
      await flnp.zonedSchedule(
        id,
        title,
        body,
        tzWhen,
        kLoudDetails,
        androidScheduleMode:
            canExact
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.inexact,
      );
    }
  }
}
