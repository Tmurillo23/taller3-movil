import 'package:flutter/material.dart';

import '../models/mood_model.dart';

class MoodTile extends StatelessWidget {
  final MoodModel mood;

  const MoodTile({
    super.key,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        title: Text(
          mood.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              'Estado de ánimo: ${mood.emocion}',
            ),

            if (mood.nota != null &&
                mood.nota!.isNotEmpty)
              Text(
                'Nota: ${mood.nota}',
              ),

            const SizedBox(height: 6),

            Text(
              'Fecha: ${mood.fechaCreacion.toLocal()}',
              style: const TextStyle(fontSize: 12),
            ),

            if (mood.pendingSync)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Chip(
                  label: Text('Sync pendiente'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}