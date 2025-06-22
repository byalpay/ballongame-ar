import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../game/balloon_game.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

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
                    onPressed: () async {
                      final game = BalloonGame();
                      final scores = await game.getHighScores();
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => _HighScoresDialog(scores: scores),
                      );
                    },
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
                    onPressed: _exitApp,
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

  void _exitApp() {
    // Çıkış fonksiyonu (mobilde uygulamadan çıkış için)
    try {
      FlutterExitApp.exitApp(iosForceExit: true);
    } catch (e) {}
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.redAccent],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  '🎮 Nasıl Oynanır?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInstruction('🎯', 'Ekranda yukarı doğru çıkan balonlara dokunarak patlat!'),
                    _buildInstruction('📏', 'Büyük balonlar daha fazla puan kazandırır.'),
                    _buildInstruction('🔴', 'Kırmızı balonları patlatırsan 5 puan kaybedersin.'),
                    _buildInstruction('💨', 'Balon kaçırırsan puanın 1 azalır.'),
                    _buildInstruction('⭐', 'Her 20 puanda bir sonraki levele geçersin, balonlar daha hızlı çıkar.'),
                    _buildInstruction('🏆', '10. levele ulaşırsan oyunu kazanırsın!'),
                    _buildInstruction('🎈', 'Farklı renk ve boyutlarda balonlar var, büyük balonlar daha çok puan verir.'),
                    _buildInstruction('🔥', 'En yüksek skoru yapmaya çalış!'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Anladım!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighScoresDialog extends StatelessWidget {
  final List<Map<String, dynamic>> scores;
  const _HighScoresDialog({required this.scores, super.key});

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 40), // Altın
      const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 40), // Gümüş
      const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 40), // Bronz
    ];
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Text(
                '🏆 En Yüksek Skorlar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: scores.isEmpty
                  ? const Column(
                      children: [
                        Icon(Icons.sports_esports, size: 60, color: Colors.white70),
                        SizedBox(height: 16),
                        Text(
                          'Henüz skor kaydedilmedi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Oyun oynayarak ilk skorunu yap!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: List.generate(scores.length, (i) {
                        final s = scores[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: icons[i],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${s['score']} puan',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(s['date']),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Kapat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 