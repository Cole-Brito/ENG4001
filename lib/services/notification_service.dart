// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// //import 'package:flutter/material.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     // Initialize timezone
//     tz.initializeTimeZones();

//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const iOSSettings = DarwinInitializationSettings();

//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iOSSettings,
//     );

//     await _notificationsPlugin.initialize(initSettings);
//   }

//   static Future<void> showInstantNotification({
//     required String title,
//     required String body,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'instant_channel',
//       'Instant Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const iOSDetails = DarwinNotificationDetails();

//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );

//     await _notificationsPlugin.show(0, title, body, details);
//   }

//   static Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required DateTime scheduleTime,
//   }) async {
//     await _notificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       tz.TZDateTime.from(scheduleTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'scheduled_channel',
//           'Scheduled Notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }
