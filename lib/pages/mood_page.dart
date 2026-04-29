import 'package:flutter/material.dart';

import '../data/mood_data.dart';
import '../models/mood_model.dart';
import '../widgets/mood_tile.dart';
import '../widgets/mood_note.dart'; 
class MoodsPage extends StatefulWidget {
  const MoodsPage({super.key});

  @override
  State<MoodsPage> createState() => _MoodsPageState();
}

class _MoodsPageState extends State<MoodsPage> {
  late List<MoodModel> _moods;

  @override
  void initState() {
    super.initState();
    _moods = List.from(moods);
  }

  Future<void> _goToAddMood() async {
  final newMood = await showDialog<MoodModel>(
    context: context,
    builder: (_) => const MoodNote(),
  );

  if (newMood == null) return;

  setState(() {
    _moods.add(newMood);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis estados de ánimo'),
      ),
      body: _moods.isEmpty
          ? const Center(
              child: Text('No hay estados de ánimo registrados'),
            )
          : ListView.builder(
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                return MoodTile(mood: _moods[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddMood,
        child: const Icon(Icons.add),
      ),
    );
  }
}