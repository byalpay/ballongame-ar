import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/balloon_game.dart';

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
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: BalloonGame(),
        overlayBuilderMap: {
          'pause': (context, game) => const PauseMenu(),
        },
      ),
    );
  }
}

class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key});

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
                // Oyunu devam ettir
              },
              child: const Text('Devam Et'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Oyunu yeniden başlat
              },
              child: const Text('Yeniden Başlat'),
            ),
          ],
        ),
      ),
    );
  }
}