import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'balloon_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balon Patlatma Oyunu',
      debugShowCheckedModeBanner: false,
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  void _exitGame() {
    FlutterExitApp.exitApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎈 Balon Patlatma Oyunu 🎈',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GameWidget(game: BalloonGame()),
                  ),
                );
              },
              child: const Text('Başla'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exitGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Çıkış'),
            ),
          ],
        ),
      ),
    );
  }
}
