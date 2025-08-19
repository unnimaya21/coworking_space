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

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'booking_live',
    'Booking Live Alerts',
    description: 'Time-sensitive booking reminders.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static const NotificationDetails _kLoudDetails = NotificationDetails(
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
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse _) async {},
    );

    final android =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await android?.requestNotificationsPermission();

    await android?.createNotificationChannel(_channel);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _kLoudDetails,
      payload: 'direct',
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Nudge to future if needed
    final now = DateTime.now().add(const Duration(seconds: 2));
    final when =
        scheduledDate.isAfter(now)
            ? scheduledDate
            : DateTime.now().add(const Duration(seconds: 5));

    final tzTime = tz.TZDateTime.from(when, tz.local);

    final android =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    final canExact =
        await (android?.canScheduleExactNotifications() ??
            Future<bool>.value(false));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      _kLoudDetails,
      androidScheduleMode:
          canExact!
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexact,
    );

    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    log(
      '$canExact PENDING: ${pending.map((e) => {'id': e.id, 'title': e.title}).toList()}',
    );
  }

  Future<void> requestAndroidPermissions() async {
    final android =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await android?.requestNotificationsPermission();

    bool? allowed =
        await (android?.canScheduleExactNotifications() ??
            Future<bool>.value(false));
    if (!allowed!) {
      await android?.requestExactAlarmsPermission(); // opens OS screen
    }
  }

  Future<bool> ensureExactAlarmPerm() async {
    if (!Platform.isAndroid) return true;
    final android =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    bool? allowed =
        await (android?.canScheduleExactNotifications() ??
            Future<bool>.value(false));
    if (!allowed!) {
      await android?.requestExactAlarmsPermission();
      allowed =
          await (android?.canScheduleExactNotifications() ??
              Future<bool>.value(false));
    }
    return allowed!;
  }

  final MethodChannel _platform = const MethodChannel(
    'app.exact_alarm.settings',
  );
  Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _platform.invokeMethod('open_exact_alarm_settings');
    } catch (_) {}
  }

  Future<void> scheduleExactIn20s() async {
    final android =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    bool? canExact =
        await (android?.canScheduleExactNotifications() ?? Future.value(false));
    if (!canExact!) {
      await android
          ?.requestExactAlarmsPermission(); // opens Alarms & reminders settings
      canExact =
          await (android?.canScheduleExactNotifications() ??
              Future.value(false));
    }

    if (!canExact!) {
      await android?.requestExactAlarmsPermission();
    }

    final when = DateTime.now().add(const Duration(seconds: 20));
    final tzWhen = tz.TZDateTime.from(when, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      4242,
      'Exact test',
      canExact
          ? 'Exact alarm: should fire ~20s from now'
          : 'Inexact alarm: OS may delay this',
      tzWhen,
      _kLoudDetails,
      androidScheduleMode:
          canExact
              ? AndroidScheduleMode.exact
              : AndroidScheduleMode.inexactAllowWhileIdle,
    );

    // Optional debug
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logTimeDiag(when);
    log(
      '$canExact pending=${pending.map((e) => {'id': e.id, 'title': e.title}).toList()}',
    );
  }

  void logTimeDiag(DateTime wallClockLocal) {
    final nowWall = DateTime.now();
    final nowTz = tz.TZDateTime.now(tz.local);
    final schedTz = tz.TZDateTime.from(wallClockLocal, tz.local);
    final delta = wallClockLocal.difference(nowWall).inSeconds;

    log('[time] tz.local=${tz.local.name}');
    log('[time] now(wall)=$nowWall now(tz)=$nowTz');
    log(
      '[time] requested(wall)=$wallClockLocal → scheduled(tz)=$schedTz (Δ=${delta}s)',
    );
  }
}
