import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'components/balloon.dart';
import '../core/constants/game_constants.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BalloonGame extends FlameGame with TapCallbacks {
  final Random _random = Random();
  int _score = 0;
  int _missedBalloons = 0;
  bool _isPaused = false;
  int _level = 1;

  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> levelNotifier = ValueNotifier<int>(1);

  int get score => _score;
  bool get isPaused => _isPaused;
  int get level => _level;
  static const int maxLevel = 10;
  static const int scorePerLevel = 20;
  static const List<double> balloonSizes = [80.0, 110.0, 150.0, 190.0]; // Küçükten büyüğe
  static const List<int> balloonPoints = [1, 2, 3, 4];

  void increaseScore() {
    _score++;
    try {
      scoreNotifier.value = _score;
      _checkLevelUp();
      _checkHighScore();
    } catch (e) {}
  }

  void decreaseScore([int value = 1]) {
    _score -= value;
    if (_score < 0) {
      _score = 0;
      try {
        overlays.add('gameover');
      } catch (e) {}
    }
    try {
      scoreNotifier.value = _score;
    } catch (e) {}
  }

  void pauseGame() {
    _isPaused = true;
    pauseEngine();
    overlays.add('pause');
  }

  void resumeGame() {
    _isPaused = false;
    resumeEngine();
    overlays.remove('pause');
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startSpawningBalloons();
    overlays.add('score');
  }

  @override
  Color backgroundColor() => Colors.lightBlue;

  void _checkLevelUp() {
    int newLevel = (_score ~/ scorePerLevel) + 1;
    if (newLevel > maxLevel) newLevel = maxLevel;
    if (newLevel > _level) {
      _level = newLevel;
      levelNotifier.value = _level;
      if (_level <= maxLevel) {
        overlays.add('levelup');
        Future.delayed(const Duration(seconds: 1), () {
          try { overlays.remove('levelup'); } catch (e) {}
        });
      }
      if (_level == maxLevel) {
        overlays.add('gamewin');
      }
    }
  }

  int get _currentSpawnDelay {
    // Level arttıkça balonlar daha hızlı gelsin
    int base = 350;
    int minDelay = 120;
    int delay = base - ((_level - 1) * 25);
    if (delay < minDelay) delay = minDelay;
    return delay;
  }

  void _startSpawningBalloons() {
    Future.doWhile(() async {
      _spawnBalloon();
      await Future.delayed(Duration(milliseconds: _currentSpawnDelay));
      return true;
    });
  }

  void _spawnBalloon() {
    final screenWidth = size.x;
    final randomX = _random.nextDouble() * (screenWidth - GameConstants.balloonSize);
    final randomColor = GameConstants.balloonColors[_random.nextInt(GameConstants.balloonColors.length)];
    final randomSpeed = GameConstants.balloonSpeeds[_random.nextInt(GameConstants.balloonSpeeds.length)];
    final sizeIndex = _random.nextInt(GameConstants.balloonSizes.length);
    final randomSize = GameConstants.balloonSizes[sizeIndex];
    final pointValue = GameConstants.balloonPoints[sizeIndex];

    final balloon = BalloonComponent(
      onPopped: (Color color, int point) {
        if (color == Colors.red) {
          decreaseScore(5);
        } else {
          for (int i = 0; i < point; i++) {
            increaseScore();
          }
        }
      },
      speed: randomSpeed,
      color: randomColor,
      size: randomSize,
      point: pointValue,
    );
    balloon.position = Vector2(randomX, size.y + randomSize);
    add(balloon);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Ekranın üstünden çıkan balonları say
    children.whereType<BalloonComponent>().forEach((balloon) {
      if (balloon.y < -GameConstants.balloonSize) {
        _missedBalloons++;
        decreaseScore();
        balloon.removeFromParent();

        if (_missedBalloons >= 3) {
          _missedBalloons = 0; // Sadece sayaç sıfırlansın, oyun durmasın
        }
      }
    });
  }

  void restart() {
    _score = 0;
    _missedBalloons = 0;
    _isPaused = false;
    _level = 1;
    levelNotifier.value = 1;
    children.clear();
    overlays.add('score');
    resumeEngine();
    _startSpawningBalloons();
  }

  Future<void> saveHighScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().toIso8601String();
      List<String> scores = prefs.getStringList('high_scores') ?? [];
      scores.add(jsonEncode({'score': score, 'date': now}));
      // En iyi 3 skoru tut
      scores.sort((a, b) {
        final sa = jsonDecode(a)['score'] as int;
        final sb = jsonDecode(b)['score'] as int;
        return sb.compareTo(sa);
      });
      if (scores.length > 3) scores = scores.sublist(0, 3);
      await prefs.setStringList('high_scores', scores);
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>> getHighScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> scores = prefs.getStringList('high_scores') ?? [];
      return scores.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  void _checkHighScore() async {
    // Oyun bittiğinde veya skor artınca çağrılabilir
    await saveHighScore(_score);
  }
} 