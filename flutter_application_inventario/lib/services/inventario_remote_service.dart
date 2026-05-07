import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventario_model.dart';

class InventarioRemoteService {
  final CollectionReference<Map<String, dynamic>> _productosRef =
      FirebaseFirestore.instance.collection('productos');

  Future<void> upsertProducto(ProductoModel producto) async {
    if (producto.id == null) {
      return;
    }
    try {
      await _productosRef.doc(producto.id.toString()).set(producto.toFirestore());
    } on FirebaseException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<ProductoModel>> fetchProductos() async {
    try {
      final snapshot = await _productosRef.get();
      return snapshot.docs.map((doc) {
        return ProductoModel.fromFirestore(doc.data(), id: int.parse(doc.id));
      }).toList();
    } on FirebaseException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}