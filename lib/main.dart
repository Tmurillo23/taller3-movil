import 'package:flutter/material.dart';
import 'pages/mood_page.dart';
import 'widgets/mood_note.dart'; // ← tu página de agregar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MoodsPage(),
      routes: {
        '/add': (context) => const MoodNote(), // ← ajusta el nombre de la clase
      },
    );
  }
}