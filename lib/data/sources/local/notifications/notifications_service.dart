import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationsService._();

  static Future<NotificationsService> create() async {
    final instance = NotificationsService._();
    await instance._init();
    return instance;
  }

  Future<void> scheduleNotification({
    required String androidChannelId,
    required String androidChannelName,
    String? title,
    String? body,
    required DateTime dateTime,
    String? payload,
  }) async {
    final list = (await checkPendingNotificationRequests()).map((e) => e.id);
    final id = list.isNotEmpty ? list.reduce((a, b) => a > b ? a : b) + 1 : 0;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannelId,
          androidChannelName,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<List<PendingNotificationRequest>> checkPendingNotificationRequests() =>
      _flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> cancelAll() => _flutterLocalNotificationsPlugin.cancelAll();

  Future<void> _init() async {
    await _configureLocalTimeZone();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
}
