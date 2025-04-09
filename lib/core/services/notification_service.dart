import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initNotification() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);
    await _createNotificationChannel();
    _initialized = true;
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'workout_reminder_channel',
      'Workout Reminders',
      description: 'Channel for workout reminder notifications',
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleWeeklyNotifications({
    required List<String> days,
    required String time,
    required String title,
    required String body,
  }) async {
    await initNotification();

    final dayMapping = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    try {
      await cancelAll();

      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      for (final day in days) {
        final dayOfWeek = dayMapping[day];
        if (dayOfWeek != null) {
          await _scheduleWeeklyNotification(
            id: dayOfWeek,
            dayOfWeek: dayOfWeek,
            hour: hour,
            minute: minute,
            title: title,
            body: body,
          );
        }
      }
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
      rethrow;
    }
  }

  Future<void> _scheduleWeeklyNotification({
    required int id,
    required int dayOfWeek,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfDayTime(dayOfWeek, hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_reminder_channel',
          'Workout Reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'workout_reminder_$id',
    );
  }

  tz.TZDateTime _nextInstanceOfDayTime(int dayOfWeek, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 7))
        : scheduledDate;
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
