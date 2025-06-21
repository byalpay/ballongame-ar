import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onShowScores;
  final VoidCallback onExit;
  const MainMenuScreen({required this.onStart, required this.onShowScores, required this.onExit, super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  final List<_Balloon> _balloons = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(() => setState(() {}))
      ..repeat();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) => _spawnBalloon());
  }

  void _spawnBalloon() {
    if (_balloons.length < 12) {
      _balloons.add(_Balloon(
        x: _random.nextDouble(),
        y: 1.2,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        speed: 0.1 + _random.nextDouble() * 0.15,
        size: 40.0 + _random.nextDouble() * 30.0,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateBalloons();
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _BalloonPainter(_balloons),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Balon Patlatma',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Oyuna Başla'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const _HowToPlayDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Nasıl Oynanır?'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.onShowScores,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Skor Tablosu'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.onExit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Çıkış'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateBalloons() {
    for (final balloon in _balloons) {
      balloon.y -= balloon.speed * 0.015;
    }
    _balloons.removeWhere((b) => b.y < -0.2);
  }
}

class _Balloon {
  double x;
  double y;
  final Color color;
  final double speed;
  final double size;
  _Balloon({required this.x, required this.y, required this.color, required this.speed, required this.size});
}

class _BalloonPainter extends CustomPainter {
  final List<_Balloon> balloons;
  _BalloonPainter(this.balloons);

  @override
  void paint(Canvas canvas, Size size) {
    for (final balloon in balloons) {
      final Offset center = Offset(balloon.x * size.width, balloon.y * size.height);
      final double radius = balloon.size / 2;
      final Paint paint = Paint()..color = balloon.color;
      final Paint stroke = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      final Paint highlight = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      final Paint basePaint = Paint()..color = Colors.orange;
      final Paint stringPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2;

      // Balon
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius, stroke);
      canvas.drawCircle(center.translate(10, -10), 8, highlight);
      canvas.drawRect(
        Rect.fromCenter(center: center.translate(0, radius + 5), width: 20, height: 8),
        basePaint,
      );
      final path = Path();
      path.moveTo(center.dx, center.dy + radius + 10);
      path.relativeLineTo(0, 10);
      path.relativeLineTo(-5, 10);
      path.relativeLineTo(5, 10);
      path.relativeLineTo(-5, 10);
      path.relativeLineTo(5, 10);
      canvas.drawPath(path, stringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BalloonPainter oldDelegate) => true;
}

class _HowToPlayDialog extends StatelessWidget {
  const _HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nasıl Oynanır?'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Ekranda yukarı doğru çıkan balonlara dokunarak patlat!'),
            SizedBox(height: 8),
            Text('• Büyük balonlar daha fazla puan kazandırır.'),
            SizedBox(height: 8),
            Text('• Kırmızı balonları patlatırsan 5 puan kaybedersin.'),
            SizedBox(height: 8),
            Text('• Balon kaçırırsan puanın 1 azalır.'),
            SizedBox(height: 8),
            Text('• Her 20 puanda bir sonraki levele geçersin, balonlar daha hızlı çıkar.'),
            SizedBox(height: 8),
            Text('• 10. levele ulaşırsan oyunu kazanırsın!'),
            SizedBox(height: 8),
            Text('• Farklı renk ve boyutlarda balonlar var, büyük balonlar daha çok puan verir.'),
            SizedBox(height: 8),
            Text('• En yüksek skoru yapmaya çalış!'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tamam'),
        ),
      ],
    );
  }
} 