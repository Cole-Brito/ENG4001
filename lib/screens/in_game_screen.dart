// in_game_screen.dart

import 'package:flutter/material.dart';

class InGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('In-Game Screen')),
      body: Center(
        child: Text(
          'Welcome to the In-Game Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
