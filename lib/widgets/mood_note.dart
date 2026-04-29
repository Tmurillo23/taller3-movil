import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodNote extends StatefulWidget {
  const MoodNote({super.key});

  @override
  State<MoodNote> createState() => _MoodNoteState();
}

class _MoodNoteState extends State<MoodNote> {
  final _nombreController = TextEditingController();
  final _notaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _emocionSeleccionada = 'Feliz';

  final List<String> _emociones = [
    'Feliz',
    'Triste',
    'Enojado',
    'Ansioso',
    'Cansado',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      MoodModel(
        nombre: _nombreController.text.trim(),
        emocion: _emocionSeleccionada,
        nota: _notaController.text.trim(),
        fechaCreacion: DateTime.now(),
        pendingSync: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo estado de ánimo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingrese un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _emocionSeleccionada,
              decoration: const InputDecoration(labelText: 'Emoción'),
              items: _emociones.map((emocion) {
                return DropdownMenuItem(
                  value: emocion,
                  child: Text(emocion),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _emocionSeleccionada = value!);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notaController,
              decoration: const InputDecoration(labelText: 'Nota (opcional)'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}