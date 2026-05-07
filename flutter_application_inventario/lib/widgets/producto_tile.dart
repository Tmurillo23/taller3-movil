import 'package:flutter/material.dart';

import '../models/inventario_model.dart';

class ProductoTile extends StatelessWidget {
  final ProductoModel producto;
  final VoidCallback? onEdit;

  const ProductoTile({
    super.key,
    required this.producto,
    this.onEdit,
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
          producto.nombreProducto,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          tooltip: 'Editar producto',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              'Categoría: ${producto.categoria}',
            ),

            const SizedBox(height: 6),

            Text(
              'Fecha: ${producto.fechaRestock.toLocal()}',
              style: const TextStyle(fontSize: 12),
            ),

            if (producto.pendingSync)
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