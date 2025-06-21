import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'components/balloon.dart';
import '../core/constants/game_constants.dart';
import 'dart:math';

class BalloonGame extends FlameGame with TapCallbacks {
  final Random _random = Random();
  int _score = 0;
  int _missedBalloons = 0;
  bool _isGameOver = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startSpawningBalloons();
  }

  @override
  Color backgroundColor() => Colors.lightBlue;

  void _startSpawningBalloons() {
    Future.doWhile(() async {
      if (!_isGameOver) {
        _spawnBalloon();
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
      return false;
    });
  }

  void _spawnBalloon() {
    if (_isGameOver) return;

    final screenWidth = size.x;
    final randomX = _random.nextDouble() * (screenWidth - GameConstants.balloonSize);
    final randomColor = GameConstants.balloonColors[_random.nextInt(GameConstants.balloonColors.length)];

    final balloon = BalloonComponent();
    balloon.position = Vector2(randomX, size.y + GameConstants.balloonSize);
    add(balloon);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isGameOver) return;

    // Ekranın üstünden çıkan balonları say
    children.whereType<BalloonComponent>().forEach((balloon) {
      if (balloon.y < -GameConstants.balloonSize) {
        _missedBalloons++;
        balloon.removeFromParent();

        if (_missedBalloons >= 3) {
          _gameOver();
        }
      }
    });
  }

  void _gameOver() {
    _isGameOver = true;
    // Oyun sonu ekranını göster
  }

  void restart() {
    _score = 0;
    _missedBalloons = 0;
    _isGameOver = false;
    children.clear();
    _startSpawningBalloons();
  }
} 