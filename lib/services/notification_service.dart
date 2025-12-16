import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

/// Service for handling local notifications.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late tz.Location _localLocation;

  /// Initialize notifications
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    _localLocation = tz.getLocation(currentTimeZone.identifier);
    tz.setLocalLocation(_localLocation);
    log('🌍 Timezone initialized: ${currentTimeZone.identifier}');

    // Request permissions
    await _requestNotificationPermissions();

    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    _isInitialized = true;
    log('✅ Notification service initialized');
  }

  void _onNotificationTap(NotificationResponse response) {
    log('📲 Notification tapped: ${response.payload}');
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      log('📢 Android Notification Permission: ${status.name}');
    }
  }

  /// Check if notification permission is granted
  Future<bool> hasNotificationPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return true;
  }

  /// Notification details with custom sound from assets
  NotificationDetails _notificationDetails({String soundName = 'beep'}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel_id',
        'General Notifications',
        channelDescription: 'General app notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundName),
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // in ios need full file name with extension (e.g., chime.wav)
        sound: 'ping.wav', // file name only
      ),
    );
  }

  /// Show immediate notification with custom sound
  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    String soundName = 'beep',
  }) async {
    await notificationPlugin.show(
      id,
      title,
      body,
      _notificationDetails(soundName: soundName),
      payload: payload,
    );
    log('✅ Immediate notification shown (ID: $id) - Sound: $soundName');
  }

  /// Schedule one-time notification with custom sound
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
    String soundName = 'beep',
  }) async {
    try {
      bool hasPermission = await hasNotificationPermission();
      if (!hasPermission) {
        throw Exception('Notification permission not granted');
      }

      final tzDateTime = tz.TZDateTime.from(dateTime, _localLocation);
      final now = tz.TZDateTime.now(_localLocation);
      final secondsUntil = tzDateTime.difference(now).inSeconds;

      if (tzDateTime.isBefore(now)) {
        throw Exception('Cannot schedule notification in the past');
      }

      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        _notificationDetails(soundName: soundName),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
      log(
        '✅ Scheduled notification (ID: $id) - fires in $secondsUntil seconds - Sound: $soundName',
      );
    } catch (e) {
      log('❌ Error scheduling notification: $e');
      rethrow;
    }
  }

  /// Schedule daily notification with custom sound
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    String soundName = 'beep',
  }) async {
    try {
      final now = tz.TZDateTime.now(_localLocation);
      var scheduleDate = tz.TZDateTime(
        _localLocation,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduleDate.isBefore(now)) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }

      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduleDate,
        _notificationDetails(soundName: soundName),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      log(
        '✅ Daily notification scheduled (ID: $id) at $hour:$minute - Sound: $soundName',
      );
    } catch (e) {
      log('❌ Error scheduling daily notification: $e');
      rethrow;
    }
  }

  /// Schedule weekly notification with custom sound
  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required List<int> weekdays,
    required int hour,
    required int minute,
    String? payload,
    String soundName = 'beep',
  }) async {
    try {
      final now = tz.TZDateTime.now(_localLocation);

      for (int i = 0; i < weekdays.length; i++) {
        int day = weekdays[i];
        int daysUntilTarget = (day - now.weekday) % 7;

        if (daysUntilTarget == 0 &&
            (now.hour > hour || (now.hour == hour && now.minute >= minute))) {
          daysUntilTarget = 7;
        }

        var scheduleDate = tz.TZDateTime(
          _localLocation,
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        ).add(Duration(days: daysUntilTarget));

        await notificationPlugin.zonedSchedule(
          id + i,
          title,
          body,
          scheduleDate,
          _notificationDetails(soundName: soundName),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: payload,
        );
      }
      log('✅ Weekly notification scheduled (ID: $id) - Sound: $soundName');
    } catch (e) {
      log('❌ Error scheduling weekly notification: $e');
      rethrow;
    }
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id);
    log('❌ Notification cancelled (ID: $id)');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
    log('❌ All notifications cancelled');
  }

  /// Debug status
  Future<void> debugStatus() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final hasPermission = await hasNotificationPermission();
    log('🔍 DEBUG STATUS');
    log('   Timezone: $currentTimeZone');
    log('   Current Time: ${tz.TZDateTime.now(_localLocation)}');
    log('   Is Initialized: $_isInitialized');
    log(
      '   Notification Permission: ${hasPermission ? "✅ Granted" : "❌ Denied"}',
    );
  }
}
