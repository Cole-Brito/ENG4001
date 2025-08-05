import 'package:test/test.dart';
import '../lib/game_timer.dart';

void main() {
  group('GameTimer Tests', () {
    test('timer starts and tracks elapsed time', () async {
      final timer = GameTimer(timeLimitSeconds: 5);
      timer.start();
      
      expect(timer.isRunning, isTrue);
      expect(timer.elapsedSeconds, equals(0));
      
      // Wait a bit and check elapsed time
      await Future.delayed(Duration(milliseconds: 1100));
      expect(timer.elapsedSeconds, greaterThan(0));
      
      timer.stop();
      expect(timer.isRunning, isFalse);
    });

    test('timer calculates remaining time correctly', () {
      final timer = GameTimer(timeLimitSeconds: 10);
      expect(timer.remainingSeconds, equals(10));
      
      timer.start();
      // Initially should have close to full time
      expect(timer.remainingSeconds, greaterThan(8));
      timer.stop();
    });

    test('timer formats time correctly', () {
      final timer = GameTimer(timeLimitSeconds: 125); // 2:05
      expect(timer.formattedRemainingTime, equals('02:05'));
      
      // Test with elapsed time
      timer.start();
      timer.stop();
      expect(timer.formattedElapsedTime, matches(RegExp(r'\d{2}:\d{2}')));
    });

    test('timer calls onTimeExpired when time runs out', () async {
      bool timeExpiredCalled = false;
      final timer = GameTimer(timeLimitSeconds: 1);
      
      timer.onTimeExpired = () {
        timeExpiredCalled = true;
      };
      
      timer.start();
      
      // Wait for timer to expire
      await Future.delayed(Duration(milliseconds: 1200));
      
      expect(timeExpiredCalled, isTrue);
      expect(timer.isTimeExpired, isTrue);
    });

    test('timer can be reset', () {
      final timer = GameTimer(timeLimitSeconds: 10);
      timer.start();
      timer.stop();
      
      timer.reset();
      expect(timer.elapsedSeconds, equals(0));
      expect(timer.isTimeExpired, isFalse);
      expect(timer.isRunning, isFalse);
    });

    test('timer handles tick callbacks', () async {
      final List<int> tickValues = [];
      final timer = GameTimer(timeLimitSeconds: 3);
      
      timer.onTick = (remainingSeconds) {
        tickValues.add(remainingSeconds);
      };
      
      timer.start();
      
      // Wait for a few ticks
      await Future.delayed(Duration(milliseconds: 2500));
      timer.stop();
      
      expect(tickValues, isNotEmpty);
      expect(tickValues.first, greaterThan(tickValues.last));
    });
  });
}