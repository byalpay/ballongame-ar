import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/balloon_game.dart';
import 'screens/main_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balon Patlatma Oyunu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenuOrGame(),
    );
  }
}

class MainMenuOrGame extends StatefulWidget {
  const MainMenuOrGame({super.key});

  @override
  State<MainMenuOrGame> createState() => _MainMenuOrGameState();
}

class _MainMenuOrGameState extends State<MainMenuOrGame> {
  bool _inGame = false;

  void _startGame() {
    setState(() {
      _inGame = true;
    });
  }

  void _showScores() {
    // Skor tablosu için bir dialog veya başka bir ekran açılabilir
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skor Tablosu'),
        content: const Text('Skor tablosu burada gösterilecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _exitApp() {
    // Çıkış fonksiyonu (mobilde uygulamadan çıkış için)
    try {
      // ignore: deprecated_member_use
      Future.delayed(const Duration(milliseconds: 200), () => Navigator.of(context).maybePop());
    } catch (e) {}
  }

  void _backToMenu() {
    setState(() {
      _inGame = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_inGame) {
      return GameScreen(onExit: _backToMenu);
    } else {
      return MainMenuScreen(
        onStart: _startGame,
        onShowScores: _showScores,
        onExit: _exitApp,
      );
    }
  }
}

class GameScreen extends StatefulWidget {
  final VoidCallback? onExit;
  const GameScreen({this.onExit, super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BalloonGame _game;

  @override
  void initState() {
    super.initState();
    _game = BalloonGame();
  }

  void _pauseGame() {
    try {
      _game.pauseGame();
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          'pause': (context, game) => PauseMenu(game: _game, onMainMenu: widget.onExit),
          'score': (context, game) => ScoreOverlay(game: _game, onPause: _pauseGame),
          'gameover': (context, game) => GameOverOverlay(onMainMenu: widget.onExit),
          'levelup': (context, game) => LevelUpOverlay(level: _game.level),
          'gamewin': (context, game) => GameWinOverlay(onMainMenu: widget.onExit),
        },
      ),
    );
  }
}

class ScoreOverlay extends StatelessWidget {
  final BalloonGame game;
  final VoidCallback onPause;
  const ScoreOverlay({required this.game, required this.onPause, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.scoreNotifier,
      builder: (context, value, child) {
        return SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Skor:  $value',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white, size: 32),
                  onPressed: onPause,
                  tooltip: 'Duraklat',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PauseMenu extends StatelessWidget {
  final BalloonGame game;
  final VoidCallback? onMainMenu;
  const PauseMenu({required this.game, this.onMainMenu, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Oyun Duraklatıldı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                try {
                  game.resumeGame();
                } catch (e) {}
              },
              child: const Text('Devam Et'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                try {
                  game.restart();
                } catch (e) {}
              },
              child: const Text('Yeniden Başlat'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (onMainMenu != null) {
                  try {
                    onMainMenu!();
                  } catch (e) {}
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Ana Menüye Dön'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  final VoidCallback? onMainMenu;
  const GameOverOverlay({this.onMainMenu, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kaybettin!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onMainMenu,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red, textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              child: const Text('Ana Menüye Dön'),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelUpOverlay extends StatelessWidget {
  final int level;
  const LevelUpOverlay({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.9),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$level. Leveli Aştınız!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameWinOverlay extends StatelessWidget {
  final VoidCallback? onMainMenu;
  const GameWinOverlay({this.onMainMenu, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.9),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tebrikler, oyunu bitirdin!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onMainMenu,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blueAccent, textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              child: const Text('Ana Menüye Dön'),
            ),
          ],
        ),
      ),
    );
  }
}