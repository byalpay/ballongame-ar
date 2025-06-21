import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/rendering.dart';
import 'dart:math';
import '../../../core/constants/game_constants.dart';

class BalloonComponent extends CustomPainterComponent with TapCallbacks {
  final void Function(Color, int)? onPopped;
  final double speed;
  final Color color;
  final double sizeValue;
  final int point;
  bool _isExploding = false;
  double _explosionTimer = 0.0;
  final double _explosionDuration = GameConstants.explosionDuration;

  BalloonComponent({this.onPopped, this.speed = GameConstants.balloonSpeed, required this.color, required double size, required this.point})
    : sizeValue = size,
      super(
        size: Vector2(size, size),
        painter: BalloonPainter(frame: 0, color: color, radius: size / 2 - 47),
      );

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isExploding) {
      y -= speed * dt;

      if (y < -size.y) {
        removeFromParent();
      }
    } else {
      _explosionTimer += dt;
      final progress = (_explosionTimer / _explosionDuration).clamp(0.0, 1.0);
      
      // Frame değerini hesapla (0, 1, 2)
      int currentFrame = (progress * 2).floor().clamp(0, 2);
      
      (painter as BalloonPainter).frame = currentFrame;

      if (_explosionTimer >= _explosionDuration) {
        removeFromParent();
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    explode();
  }

  void explode() {
    if (!_isExploding) {
      _isExploding = true;
      _explosionTimer = 0.0;
      if (onPopped != null) {
        try {
          onPopped!(color, point);
        } catch (e) {
          // Hata olursa sessizce geç
        }
      }
    }
  }
}

class BalloonPainter extends CustomPainter {
  int frame;
  final Color color;
  final double radius;

  BalloonPainter({required this.frame, required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2 - 20);
    final double r = radius;

    final balloonPaint = Paint()..color = color;
    final strokePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    final basePaint = Paint()..color = Colors.orange;
    final stringPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final burstPaint = Paint()
      ..color = frame == 2 ? color.withOpacity(0.6) : Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    if (frame == 0) {
      // 🎈 Balon - İlk kare
      canvas.drawCircle(center, r, balloonPaint);
      canvas.drawCircle(center, r, strokePaint);

      canvas.drawCircle(center.translate(10, -10), 8, highlightPaint);

      canvas.drawRect(
        Rect.fromCenter(center: center.translate(0, r + 5), width: 20, height: 8),
        basePaint,
      );

      final path = Path();
      path.moveTo(center.dx, center.dy + r + 10);
      path.relativeLineTo(0, 10);
      path.relativeLineTo(-5, 10);
      path.relativeLineTo(5, 10);
      path.relativeLineTo(-5, 10);
      path.relativeLineTo(5, 10);
      canvas.drawPath(path, stringPaint);
    } else if (frame == 1) {
      // 💥 Patlama başlıyor - 2. kare
      canvas.drawCircle(center, r, balloonPaint);
      canvas.drawCircle(center, r, strokePaint);
      canvas.drawCircle(center.translate(10, -10), 8, highlightPaint);
      canvas.drawRect(
        Rect.fromCenter(center: center.translate(0, r + 5), width: 20, height: 8),
        basePaint,
      );
      final path = Path();
      path.moveTo(center.dx, center.dy + r + 10);
      path.relativeLineTo(0, 10);
      path.relativeLineTo(-5, 10);
      path.relativeLineTo(5, 10);
      path.relativeLineTo(-5, 10);
      canvas.drawPath(path, stringPaint);

      _drawBurstLines(canvas, center, 40, 10, burstPaint);
    } else {
      // 💣 Tam patlama - 3. kare
      _drawBurstLines(canvas, center, 55, 14, burstPaint);
    }
  }

  void _drawBurstLines(Canvas canvas, Offset center, double radius, int rays, Paint paint) {
    for (int i = 0; i < rays; i++) {
      final angle = 2 * pi * i / rays;
      final start = center;
      final end = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BalloonPainter oldDelegate) => 
    oldDelegate.frame != frame || oldDelegate.color != color;
} 