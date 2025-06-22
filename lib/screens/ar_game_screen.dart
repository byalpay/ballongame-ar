import 'package:flutter/material.dart';

class ARGameScreen extends StatelessWidget {
  const ARGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Balon Oyunu')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_in_ar, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'AR Özelliği Yakında!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'AR balon oyunu geliştirme aşamasında...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 