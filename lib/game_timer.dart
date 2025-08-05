import 'dart:async';

/// A timer class that tracks game duration and enforces time constraints
class GameTimer {
  final int timeLimitSeconds;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _countdownTimer;
  bool _timeExpired = false;
  
  /// Callback function called when time expires
  Function()? onTimeExpired;
  
  /// Callback function called every second with remaining time
  Function(int remainingSeconds)? onTick;

  GameTimer({required this.timeLimitSeconds});

  /// Start the timer
  void start() {
    _stopwatch.start();
    _timeExpired = false;
    
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      int elapsed = _stopwatch.elapsed.inSeconds;
      int remaining = timeLimitSeconds - elapsed;
      
      if (remaining <= 0) {
        _timeExpired = true;
        timer.cancel();
        onTimeExpired?.call();
      } else {
        onTick?.call(remaining);
      }
    });
  }

  /// Stop the timer
  void stop() {
    _stopwatch.stop();
    _countdownTimer?.cancel();
  }

  /// Reset the timer
  void reset() {
    _stopwatch.reset();
    _countdownTimer?.cancel();
    _timeExpired = false;
  }

  /// Get elapsed time in seconds
  int get elapsedSeconds => _stopwatch.elapsed.inSeconds;

  /// Get remaining time in seconds
  int get remainingSeconds => 
      timeLimitSeconds - _stopwatch.elapsed.inSeconds;

  /// Check if time has expired
  bool get isTimeExpired => _timeExpired;

  /// Check if timer is running
  bool get isRunning => _stopwatch.isRunning;

  /// Get formatted elapsed time as MM:SS
  String get formattedElapsedTime {
    final duration = _stopwatch.elapsed;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted remaining time as MM:SS
  String get formattedRemainingTime {
    final remaining = remainingSeconds;
    if (remaining <= 0) return '00:00';
    
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}