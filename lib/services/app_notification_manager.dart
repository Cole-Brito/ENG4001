import '../services/notification_service.dart';
import '../models/game.dart';

/// Example service showing how to integrate notifications with your app features
class AppNotificationManager {
  static final NotificationService _notificationService = NotificationService();

  /// Send welcome notification for new users
  static Future<void> sendWelcomeNotification(String username) async {
    await _notificationService.showLocalNotification(
      title: '🎾 Welcome to ROS!',
      body: 'Hi $username! Get ready for some amazing racket sports action.',
    );
  }

  /// Notify when a game is scheduled
  static Future<void> notifyGameScheduled(Game game) async {
    await _notificationService.showLocalNotification(
      title: '🗓️ New Game Scheduled',
      body:
          '${game.format} game on ${game.date.day}/${game.date.month}/${game.date.year}',
    );

    // Also schedule a reminder 1 hour before the game
    // Generate a unique ID based on game properties
    final gameId =
        '${game.format}_${game.date.millisecondsSinceEpoch}'.hashCode;
    await _notificationService.scheduleGameReminder(
      gameId: gameId,
      gameName: game.format,
      gameDate: game.date,
      courtInfo: 'Court ${game.courts}',
      reminderBefore: const Duration(hours: 1),
    );
  }

  /// Notify about game updates
  static Future<void> notifyGameUpdate(
    String gameInfo,
    String updateDetails,
  ) async {
    await _notificationService.showLocalNotification(
      title: '📢 Game Update',
      body: '$gameInfo: $updateDetails',
    );
  }

  /// Notify about new guest requests (for admins)
  static Future<void> notifyGuestRequest(String guestName, String email) async {
    await _notificationService.showLocalNotification(
      title: '👤 New Guest Request',
      body: '$guestName ($email) wants to join a game',
    );
  }

  /// Subscribe user to relevant notification topics
  static Future<void> setupUserNotifications(String userType) async {
    if (userType == 'admin') {
      await _notificationService.subscribeToTopic('admin_notifications');
      await _notificationService.subscribeToTopic('game_requests');
    } else {
      await _notificationService.subscribeToTopic('game_updates');
      await _notificationService.subscribeToTopic('general_announcements');
    }
  }

  /// Send test notification (for debugging)
  static Future<void> sendTestNotification() async {
    await _notificationService.showLocalNotification(
      title: '🧪 Test Notification',
      body: 'This is a test notification to verify the system is working!',
    );
  }

  /// Show immediate notification for game starting soon
  static Future<void> notifyGameStartingSoon(Game game) async {
    await _notificationService.showGameReminder(
      gameName: game.format,
      gameDate: game.date,
      courtInfo: 'Court ${game.courts}',
    );
  }

  /// Schedule daily reminder for active users
  static Future<void> scheduleDailyReminder() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final reminderTime = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      9,
      0,
    ); // 9 AM

    await _notificationService.scheduleNotification(
      id: 999, // Use a fixed ID for daily reminders
      title: '🌅 Good Morning!',
      body: 'Check out today\'s games and activities in ROS!',
      scheduledDate: reminderTime,
    );
  }

  /// Cancel all game-related notifications for a specific game
  static Future<void> cancelGameNotifications(Game game) async {
    final gameId =
        '${game.format}_${game.date.millisecondsSinceEpoch}'.hashCode;
    await _notificationService.cancelNotification(gameId);
  }

  /// Get all pending notifications (useful for debugging)
  static Future<void> debugPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    print('📅 Pending notifications: ${pending.length}');
    for (var notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}');
    }
  }
}
