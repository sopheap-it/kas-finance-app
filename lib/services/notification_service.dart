import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static bool _initialized = false;

  static Future<void> init() async {
    try {
      // Initialize Firebase Messaging
      await _initFirebaseMessaging();

      // Initialize Local Notifications
      await _initLocalNotifications();

      _initialized = true;
    } catch (e) {
      // In production we should log this. Avoid crashing the app if
      // notifications are misconfigured.
      _initialized = false;
      if (kDebugMode) {
        print('NotificationService initialization failed: $e');
      }
    }
  }

  static Future<void> _initFirebaseMessaging() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // Get FCM token for this device
    String? token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification!.title ?? 'KAS Finance',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });
  }

  static Future<void> _initLocalNotifications() async {
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

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      if (kDebugMode) {
        print('NotificationService not initialized. Skipping notification.');
      }
      return;
    }
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'kas_finance_channel',
          'KAS Finance Notifications',
          channelDescription: 'Notifications for KAS Finance App',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    try {
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to show local notification: $e');
      }
    }
  }

  static Future<void> showBudgetAlert({
    required String category,
    required double spent,
    required double budget,
  }) async {
    final percentage = (spent / budget * 100).round();
    await _showLocalNotification(
      title: 'Budget Alert',
      body: 'You\'ve spent $percentage% of your $category budget',
    );
  }

  static Future<void> showBillReminder({
    required String billName,
    required DateTime dueDate,
  }) async {
    await _showLocalNotification(
      title: 'Bill Reminder',
      body: '$billName is due soon',
    );
  }

  static Future<void> scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Implementation for recurring notifications
    // This would require additional setup with timezone package
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // Handle notification tap navigation
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}
