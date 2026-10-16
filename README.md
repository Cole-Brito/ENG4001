# 🏸 ROS Mobile App

A full-featured mobile app built with **Flutter** to manage and schedule recreational games like Badminton.  
Includes features for user login, game creation, match queueing, and dashboard views for both members and admins.

---

## 📱 Features

-  **User Authentication** (Login/Register)
-  **Create & Schedule Games** with court and player limits
-  **Live Match Queue System**
  - Form groups of 4 players
  - Waitlist management
  - Auto court assignment
-  **Active Matches & Match Completion**
-  **Admin & Member Dashboards**
-  **Leaderboard** showing top players (mocked for demo)
-  **Mock backend** (can be upgraded to real API)
-  **Dark/Light Theme Support**

---

##  Project Structure

```bash
lib/
│
├── screens/               # All UI pages/screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── create_game_screen.dart
│   ├── scheduled_games_screen.dart
│   ├── game_play_screen.dart
│   ├── admin_dashboard.dart
│   ├── member_dashboard.dart
│   └── leaderboard_screen.dart
│
├── models/                # Data models
│   ├── user.dart
│   ├── game.dart
│   └── match.dart
│
├── data/                  # Temporary/mock data stores
│   ├── mock_game_store.dart
│   └── mock_users.dart
│
├── widgets/               # Reusable UI widgets
│   ├── custom_button.dart
│   ├── section_header.dart
│   ├── info_card.dart
│   └── empty_state.dart
│
├── theme/                 # Centralized app theming
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── app_theme.dart
│
└── main.dart              # App entry point

```
## 📣 Notifications Setup

To learn how to configure push notifications, see [NOTIFICATIONS_SETUP.md](NOTIFICATIONS_SETUP.md).
