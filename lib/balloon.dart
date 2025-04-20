import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Balloon extends CircleComponent with TapCallbacks {
  final Color color;
  final void Function(Balloon) onPop;

  Balloon({
    required this.color,
    required double radius,
    required Vector2 position,
    required this.onPop,
  }) : super(
          radius: radius,
          position: position,
          anchor: Anchor.center,
        ) {
    paint = Paint()..color = color;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (color == Colors.red) {
      onPop(this); // Patlat
    } else {
      // Buraya yanlış balon efekti eklenebilir
    }
  }
}
