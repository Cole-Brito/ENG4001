import 'dart:io';
import 'dart:math';
import 'game_timer.dart';

/// A simple number guessing game with time constraints
class SimpleGame {
  static const int defaultTimeLimit = 60; // 60 seconds
  late GameTimer _timer;
  late int _targetNumber;
  bool _gameCompleted = false;
  int _attempts = 0;

  SimpleGame({int timeLimit = defaultTimeLimit}) {
    _timer = GameTimer(timeLimitSeconds: timeLimit);
    _setupTimer();
  }

  void _setupTimer() {
    _timer.onTimeExpired = () {
      print('\n⏰ Time\'s up! Game over!');
      print('The number was: $_targetNumber');
      print('You made $_attempts attempts');
      print('Total time: ${_timer.formattedElapsedTime}');
      _gameCompleted = true;
    };

    _timer.onTick = (remainingSeconds) {
      // Show countdown every 10 seconds or when less than 10 seconds remain
      if (remainingSeconds % 10 == 0 || remainingSeconds <= 10) {
        stdout.write('\r⏱️  Time remaining: ${_timer.formattedRemainingTime}');
      }
    };
  }

  /// Start the game
  void start() {
    _generateTargetNumber();
    print('Guess the number between 1 and 100!');
    print('You have ${_timer.timeLimitSeconds} seconds.');
    print('Time limit: ${_timer.formattedRemainingTime}');
    print('');
    
    _timer.start();
    _gameLoop();
  }

  void _generateTargetNumber() {
    final random = Random();
    _targetNumber = random.nextInt(100) + 1; // 1 to 100
  }

  void _gameLoop() {
    while (!_gameCompleted && !_timer.isTimeExpired) {
      stdout.write('Enter your guess (1-100): ');
      
      final input = stdin.readLineSync();
      if (input == null) break;
      
      // Clear the timer display line
      print('');
      
      final guess = int.tryParse(input);
      if (guess == null) {
        print('Please enter a valid number!');
        continue;
      }
      
      if (guess < 1 || guess > 100) {
        print('Please enter a number between 1 and 100!');
        continue;
      }
      
      _attempts++;
      
      if (guess == _targetNumber) {
        _timer.stop();
        _gameCompleted = true;
        _showWinMessage();
      } else if (guess < _targetNumber) {
        print('Too low! Try a higher number.');
        _showGameStatus();
      } else {
        print('Too high! Try a lower number.');
        _showGameStatus();
      }
    }
  }

  void _showWinMessage() {
    print('🎉 Congratulations! You guessed it!');
    print('The number was: $_targetNumber');
    print('Attempts: $_attempts');
    print('Time taken: ${_timer.formattedElapsedTime}');
    print('Time remaining: ${_timer.formattedRemainingTime}');
    
    // Calculate score based on time and attempts
    final score = _calculateScore();
    print('Your score: $score points');
  }

  void _showGameStatus() {
    print('Attempts so far: $_attempts');
    print('Time elapsed: ${_timer.formattedElapsedTime}');
    print('Time remaining: ${_timer.formattedRemainingTime}');
    print('');
  }

  int _calculateScore() {
    // Base score of 1000 points
    // Subtract 10 points per attempt
    // Add bonus for remaining time (1 point per second)
    final baseScore = 1000;
    final attemptPenalty = _attempts * 10;
    final timeBonus = _timer.remainingSeconds;
    
    return (baseScore - attemptPenalty + timeBonus).clamp(0, double.infinity).toInt();
  }

  /// Get current game statistics
  Map<String, dynamic> getGameStats() {
    return {
      'attempts': _attempts,
      'elapsedTime': _timer.formattedElapsedTime,
      'remainingTime': _timer.formattedRemainingTime,
      'isCompleted': _gameCompleted,
      'isTimeExpired': _timer.isTimeExpired,
      'targetNumber': _targetNumber,
    };
  }
}