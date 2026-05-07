import '../data/app_database.dart';
import '../models/inventario_model.dart';
import 'inventario_remote_service.dart';

class InventarioRepository {
  final AppDatabase localDb;
  final InventarioRemoteService remoteService;

  InventarioRepository({required this.localDb, required this.remoteService});

  Stream<List<ProductoModel>> watchProductos() {
    return localDb.watchProductos();
  }

  Future<void> loadInitialData() async {
    await refreshFromRemote();
    await syncPendingProductos();
  }

  Future<void> addProducto({
    required String nombreProducto,
    required int stock,
    required String categoria,
  }) async {
    final localProducto = ProductoModel(
      nombreProducto: nombreProducto,
      stock: stock,
      categoria: categoria,
      fechaRestock: DateTime.now(),
      pendingSync: true,
    );
    final inserted = await localDb.insertProducto(localProducto);

    try {
      await remoteService.upsertProducto(inserted);
      if (inserted.id != null) {
        await localDb.markAsSynced(inserted.id!);
      }
    } catch (e) {
      // keep local copy pending
    }
  }

  Future<void> updateProducto({
    required ProductoModel producto,
    required String nombreProducto,
    required int stock,
    required String categoria,
  }) async {
    if (producto.id == null) {
      return;
    }

    final updatedProducto = producto.copyWith(
      nombreProducto: nombreProducto,
      stock: stock,
      categoria: categoria,
      pendingSync: true,
    );

    await localDb.updateProducto(updatedProducto);

    try {
      await remoteService.upsertProducto(updatedProducto);
      await localDb.markAsSynced(updatedProducto.id!);
    } catch (e) {
      // leave as pending
    }
  }

  Future<void> deleteProducto(int id) async {
    await localDb.deleteProducto(id);
  }

  Future<void> refreshFromRemote() async {
    try {
      final remoteProductos = await remoteService.fetchProductos();
      for (final producto in remoteProductos) {
        await localDb.upsertFromRemote(producto);
      }
    } catch (e) {
      // ignore remote errors
    }
  }

  Future<void> syncPendingProductos() async {
    final pending = await localDb.getPendingProductos();
    for (final producto in pending) {
      try {
        await remoteService.upsertProducto(producto);
        if (producto.id != null) {
          await localDb.markAsSynced(producto.id!);
        }
      } catch (e) {
        // ignore
      }
    }
  }
}