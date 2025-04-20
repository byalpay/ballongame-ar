import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'balloon.dart';

class BalloonGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final List<Color> balloonColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();

    const int numberOfBalloons = 15;
    final Random random = Random();

    for (int i = 0; i < numberOfBalloons; i++) {
      final color = balloonColors[random.nextInt(balloonColors.length)];
      final position = Vector2(
        random.nextDouble() * size.x,
        random.nextDouble() * size.y,
      );

      final balloon = Balloon(
        color: color,
        radius: 30,
        position: position,
        onPop: (b) => remove(b),
      );

      add(balloon);
    }
  }
}
