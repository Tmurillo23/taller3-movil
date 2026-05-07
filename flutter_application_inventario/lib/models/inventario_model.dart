import 'package:flutter/rendering.dart';

class ProductoModel {
  final int? id;
  final String nombreProducto;
  final int stock;
  final String categoria;
  final DateTime fechaRestock;
  final bool pendingSync;

  const ProductoModel({
    this.id,
    required this.nombreProducto,
    required this.stock,
    required this.categoria,
    required this.fechaRestock,
    required this.pendingSync,
  });

  ProductoModel copyWith({
    int? id,
    String? nombreProducto,
    int? stock,
    String? categoria,
    DateTime? fechaRestock,
    bool? pendingSync,
  }) {
    return ProductoModel(
      id: id ?? this.id,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
      fechaRestock: fechaRestock ?? this.fechaRestock,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

 
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombreProducto': nombreProducto,
      'stock': stock,
      'categoria': categoria,
      'fechaRestock': fechaRestock.toIso8601String(),//Convierte la fecha en texto ya 
    };
  }

  factory ProductoModel.fromFirestore(Map<String, dynamic> map, {required int id}) {
  return ProductoModel(
    id: id,
    nombreProducto: map['nombreProducto'] as String? ?? '',
    stock: map['stock'] as int? ?? 0,
    categoria: map['categoria'] as String? ?? '',
    fechaRestock:
        DateTime.tryParse(map['fechaRestock'] as String? ?? '') ??
        DateTime.now(),
    pendingSync: map['pendingSync'] as bool? ?? false,
  );
}
} 