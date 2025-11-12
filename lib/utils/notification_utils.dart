import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 初始化通知插件
  static Future<void> initialize() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_notification',
    );

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// 显示简单通知
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'unisub_channel',
        'UniSub Channel',
        channelDescription: 'UniSub notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// 显示带进度的通知
  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    int maxProgress = 100,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'unisub_progress_channel',
        'UniSub Progress Channel',
        channelDescription: 'UniSub progress notifications',
        importance: Importance.max,
        priority: Priority.high,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails);
  }

  /// 取消通知
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// 取消所有通知
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
