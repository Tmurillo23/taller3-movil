import 'package:flutter/material.dart';

import '../models/inventario_model.dart';

class ProductoFormResult {
  final String? nombreProducto;
  final int? stock;
  final String? categoria;
  final bool isEdit;

  const ProductoFormResult.create({
    required this.nombreProducto,
    required this.stock,
    this.categoria,
  }) : isEdit = false;

  const ProductoFormResult.edit({
    this.stock
  })  : nombreProducto = null,
        categoria = null,
        isEdit = true;
}

class InventarioFormDialog extends StatefulWidget {
  final ProductoModel? inventario;

  const InventarioFormDialog({super.key, this.inventario});

  bool get isEditMode => inventario != null;

  @override
  State<InventarioFormDialog> createState() => _InventarioFormDialogState();
}

class _InventarioFormDialogState extends State<InventarioFormDialog> {
  final _nombreController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _categoriaSeleccionada = 'Alimentos';

  final List<String> _categorias = [
    'Alimentos',
    'Limpieza',
    'Electrónica',
    'Ropa',
    'Libros',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _stockController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      widget.isEditMode
          ? ProductoFormResult.edit(
              stock: int.tryParse(_stockController.text),
            )
          : ProductoFormResult.create(
              nombreProducto: _nombreController.text.trim(),
              stock: int.tryParse(_stockController.text),
              categoria: _categoriaSeleccionada,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditMode ? 'Editar producto' : 'Nuevo producto'),
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
                    return 'Ingrese un nombre del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingrese un stock';
                }
                if (int.tryParse(value) == null) {
                  return 'Ingrese un número válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoriaSeleccionada,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: _categorias
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _categoriaSeleccionada = value!),
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