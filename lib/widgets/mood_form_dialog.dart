import 'package:flutter/material.dart';

import '../models/mood_model.dart';

class MoodFormResult {
  final String? nombre;
  final String? emocion;
  final String? nota;
  final bool isEdit;

  const MoodFormResult.create({
    required this.nombre,
    required this.emocion,
    this.nota,
  }) : isEdit = false;

  const MoodFormResult.edit({
    this.nota,
  })  : nombre = null,
        emocion = null,
        isEdit = true;
}

class MoodFormDialog extends StatefulWidget {
  final MoodModel? mood;

  const MoodFormDialog({super.key, this.mood});

  bool get isEditMode => mood != null;

  @override
  State<MoodFormDialog> createState() => _MoodFormDialogState();
}

class _MoodFormDialogState extends State<MoodFormDialog> {
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
      widget.isEditMode
          ? MoodFormResult.edit(
              nota: _notaController.text.trim().isEmpty
                  ? null
                  : _notaController.text.trim(),
            )
          : MoodFormResult.create(
              nombre: _nombreController.text.trim(),
              emocion: _emocionSeleccionada,
              nota: _notaController.text.trim().isEmpty
                  ? null
                  : _notaController.text.trim(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditMode ? 'Editar nota' : 'Nuevo estado de ánimo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isEditMode) ...[
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
                initialValue: _emocionSeleccionada,
                decoration: const InputDecoration(labelText: 'Emoción'),
                items: _emociones
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _emocionSeleccionada = value!),
              ),
              const SizedBox(height: 12),
            ],
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
          child: Text(widget.isEditMode ? 'Guardar cambios' : 'Guardar'),
        ),
      ],
    );
  }
}