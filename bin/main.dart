import 'dart:io';
import '../lib/game_timer.dart';
import '../lib/simple_game.dart';

void main() {
  print('Welcome to the Timed Game!');
  print('=====================');
  
  final game = SimpleGame();
  game.start();
  
  print('\nGame completed!');
  print('Thanks for playing!');
}