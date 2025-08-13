import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');
  debugPrint('Message notification: ${message.notification?.title}');

  // You can process the message data here and show local notification if needed
  if (message.notification != null) {
    await NotificationService._showLocalNotification(
      title: message.notification!.title ?? 'New Message',
      body: message.notification!.body ?? 'You have a new message',
      payload: jsonEncode(message.data),
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification channels
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

  static const AndroidNotificationChannel _gameUpdatesChannel =
      AndroidNotificationChannel(
        'game_updates_channel',
        'Game Updates',
        description: 'Notifications for game updates and schedules.',
        importance: Importance.defaultImportance,
        playSound: true,
      );

  // Initialize the complete notification system
  Future<void> initialize() async {
    try {
      // Initialize timezone data for scheduled notifications
      tz.initializeTimeZones();

      // Initialize Firebase Cloud Messaging
      await initFCM();

      // Initialize Local Notifications
      await initLocalNotifications();

      debugPrint('✅ Notification service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing notification service: $e');
    }
  }

  // Initialize Firebase Cloud Messaging
  Future<void> initFCM() async {
    try {
      // Set the background messaging handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request permissions
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
            criticalAlert: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ FCM: User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('⚠️ FCM: User granted provisional permission');
      } else {
        debugPrint('❌ FCM: User declined or has not accepted permission');
        return;
      }

      // Get the FCM token
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        debugPrint('✅ FCM Token: $fcmToken');
        // TODO: Send this token to your server
      } else {
        debugPrint('❌ Failed to get FCM token');
      }

      // Configure foreground notification presentation options for iOS
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle when app is opened from a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint(
          '📱 App opened from notification: ${message.notification?.title}',
        );
        _handleNotificationTap(message);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          '📱 Received foreground message: ${message.notification?.title}',
        );
        _handleForegroundMessage(message);
      });

      // Handle initial message when app is launched from terminated state
      RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '📱 App launched from notification: ${initialMessage.notification?.title}',
        );
        _handleNotificationTap(initialMessage);
      }

      debugPrint('✅ FCM initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing FCM: $e');
    }
  }

  // Initialize Local Notifications
  Future<void> initLocalNotifications() async {
    try {
      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@drawable/ic_notification');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // macOS initialization settings
      const DarwinInitializationSettings macOSSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // Linux initialization settings
      const LinuxInitializationSettings linuxSettings =
          LinuxInitializationSettings(defaultActionName: 'Open notification');

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: macOSSettings,
        linux: linuxSettings,
      );

      // Initialize with callback for when notification is tapped
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          _handleLocalNotificationTap(details);
        },
      );

      // Create notification channels for Android
      if (Platform.isAndroid) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(_defaultChannel);

        await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(_gameUpdatesChannel);
      }

      // Request permissions for iOS
      if (Platform.isIOS || Platform.isMacOS) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }

      debugPrint('✅ Local notifications initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing local notifications: $e');
    }
  }

  // Handle foreground Firebase messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Handling foreground message: ${message.notification?.title}');

    // Show local notification for foreground messages
    if (message.notification != null) {
      showLocalNotification(
        title: message.notification!.title ?? 'New Message',
        body: message.notification!.body ?? 'You have a new message',
        payload: jsonEncode(message.data),
      );
    }
  }

  // Handle notification tap from Firebase
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.data}');
    // TODO: Navigate to specific screen based on message data
    // Example: if (message.data['type'] == 'game_update') { navigate to game screen }
  }

  // Handle local notification tap
  void _handleLocalNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      try {
        Map<String, dynamic> data = jsonDecode(response.payload!);
        // TODO: Handle navigation based on payload data
        debugPrint('Payload data: $data');
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  // Show immediate local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'high_importance_channel',
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@drawable/ic_notification',
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformDetails,
        payload: payload,
      );

      debugPrint('✅ Local notification shown: $title');
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }

  // Static method for background handler
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@drawable/ic_notification',
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('❌ Error showing background local notification: $e');
    }
  }

  // Schedule a notification for later
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'high_importance_channel',
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@drawable/ic_notification',
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('✅ Notification scheduled for: $scheduledDate');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  // Show game reminder notification
  Future<void> showGameReminder({
    required String gameName,
    required DateTime gameDate,
    required String courtInfo,
  }) async {
    await showLocalNotification(
      title: '🎾 Game Reminder',
      body: '$gameName is starting soon!\nCourt: $courtInfo',
      payload: jsonEncode({
        'type': 'game_reminder',
        'game_name': gameName,
        'game_date': gameDate.toIso8601String(),
        'court_info': courtInfo,
      }),
    );
  }

  // Schedule game reminder
  Future<void> scheduleGameReminder({
    required int gameId,
    required String gameName,
    required DateTime gameDate,
    required String courtInfo,
    Duration reminderBefore = const Duration(hours: 1),
  }) async {
    final reminderTime = gameDate.subtract(reminderBefore);

    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: gameId,
        title: '🎾 Upcoming Game',
        body:
            '$gameName starts in ${reminderBefore.inHours} hour(s)!\nCourt: $courtInfo',
        scheduledDate: reminderTime,
        payload: jsonEncode({
          'type': 'game_reminder',
          'game_id': gameId,
          'game_name': gameName,
          'game_date': gameDate.toIso8601String(),
          'court_info': courtInfo,
        }),
      );
    }
  }

  // Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    debugPrint('✅ Notification $id cancelled');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    debugPrint('✅ All notifications cancelled');
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  // Update FCM token (call this when user logs in/out)
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic $topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic $topic: $e');
    }
  }
}
