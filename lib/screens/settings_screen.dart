import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final bool notificationsEnabled;
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<bool> onNotificationsChanged;

  const SettingsScreen({
    Key? key,
    required this.username,
    required this.notificationsEnabled,
    required this.onUsernameChanged,
    required this.onNotificationsChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _notificationsEnabled = widget.notificationsEnabled;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    widget.onUsernameChanged(_usernameController.text);
  }

  void _onNotificationsChanged(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    widget.onNotificationsChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF10138A),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter new admin username',
                    filled: true,
                    fillColor: const Color(0xFFF3F6FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => _onUsernameChanged(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: _onNotificationsChanged,
                      activeColor: const Color(0xFF3B82F6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
