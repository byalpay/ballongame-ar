import 'package:flutter/material.dart';

class GameConstants {
  static const List<Color> balloonColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
  ];

  static const double balloonSpeed = 50.0;
  static const double explosionDuration = 0.6;
  static const double balloonSize = 150.0;
  static const double balloonRadius = 28.0;

  static const double balloonSpeedVerySlow = 60.0;
  static const double balloonSpeedSlow = 90.0;
  static const double balloonSpeedMedium = 130.0;
  static const double balloonSpeedFast = 170.0;
  static const double balloonSpeedVeryFast = 220.0;

  static const List<double> balloonSpeeds = [
    balloonSpeedVerySlow,
    balloonSpeedSlow,
    balloonSpeedMedium,
    balloonSpeedFast,
    balloonSpeedVeryFast,
  ];

  static const List<double> balloonSizes = [130.0, 150.0, 170.0, 200.0];
  static const List<int> balloonPoints = [1, 2, 3, 4];
} 